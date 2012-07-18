//
//  ZN3DTimelineViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 15/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZN3DViewController.h"
#import "SquareObject.h"
#import "Camera.h"
#import <CoreMotion/CoreMotion.h>
#import "ZN3DEventLocation.h"

@interface ZN3DViewController () {
    //    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    GLKMatrix4          sceneModelMatrix;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    SquareObject *testObject;
    
    // Motion Manager
    BOOL                coreMotionEnabled;      // Is CoreMotion enabled
    CMMotionManager     *motionManager;
    CMAttitude          *referenceAttitude;     // Holds the initial attitude of the device
    
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)initCoreMotion;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (void)initEvent;
- (void)loadEvent;
@end


@implementation ZN3DViewController

@synthesize sceneModelMatrix;
@synthesize context;
@synthesize effect;
@synthesize currentBoundTexture;
@synthesize assetManager;
@synthesize camera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    assetManager = [[ZNAssetManager alloc] init];
    
    
    [self setupGL];
    [self initCoreMotion];
    [self initEvent];
    
    // try movement
    
    UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPan:)];
    [g setDelegate:self];
    [self.view addGestureRecognizer:g];
    
    
}

- (void)doPan:(UIPanGestureRecognizer*)recognizer {
    
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        self.camera.position = GLKVector3Make(self.camera.position.x + (translation.y), self.camera.position.y + translation.x, 0);
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    
}


- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)initCoreMotion {
    NSLog(@"Initializing CoreMotion...");
    
    // By default coremotion is not enabled
    coreMotionEnabled = NO;
    
    // Creation a CMMotionManager instance
    motionManager = [[CMMotionManager alloc] init];
    referenceAttitude = nil;
    
    // Make sure the data we need is available
    if (!motionManager.deviceMotionAvailable) {
        NSLog(@"CoreMotion Not Available");
        return;
    }
    
    // Set up the desired update interval e.g. 60 per second
    motionManager.deviceMotionUpdateInterval = 1.0f / 60;
    motionManager.gyroUpdateInterval = 1.0f / 60;
    
    // Start updates
    [motionManager startDeviceMotionUpdates];
    
    // Grab the reference attitude of the device
    referenceAttitude = motionManager.deviceMotion.attitude;
    
    [motionManager startGyroUpdates];
    [motionManager startAccelerometerUpdates];
    coreMotionEnabled = YES;
    
}

#pragma mark Open GL Core

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    //[self loadShaders];
    
    camera = [[Camera alloc] initWithGameSceneController:self];
    
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.light0.position = GLKVector4Make(100, 0, 0, 0.0f);
    self.effect.light1.enabled = GL_TRUE;
    self.effect.light1.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.light1.position = GLKVector4Make(0, 100, 0, 0.0f);
    self.effect.light2.enabled = GL_TRUE;
    self.effect.light2.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.light2.position = GLKVector4Make(0, 0, 100, 0.0f);
    
    self.effect.transform.projectionMatrix = camera.projectionMatrix;
    self.effect.lightModelTwoSided = YES;
    
    glEnable(GL_DEPTH_TEST);
    
    // SW - enable blending here
    
    glEnable(GL_BLEND);
    
    // SW - with a blend function that will allow transparency
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    
    /*
     
     glGenVertexArraysOES(1, &_vertexArray);
     glBindVertexArrayOES(_vertexArray);
     
     glGenBuffers(1, &_vertexBuffer);
     glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
     glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
     
     glEnableVertexAttribArray(GLKVertexAttribPosition);
     glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
     glEnableVertexAttribArray(GLKVertexAttribNormal);
     glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
     
     glBindVertexArrayOES(0);
     */
    
    // add a test object
    //    testObject = [[SquareObject alloc] initWithScene:self withTexture:@"icon2_114.png"];
    //    testObject.shader = self.effect;
    
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    //    if (_program) {
    //        glDeleteProgram(_program);
    //        _program = 0;
    //    }
}

#pragma mark Update loop

- (void)update {
    
    // Reset the scenes matrix
    sceneModelMatrix = GLKMatrix4Identity;
    
    // Grab the motion managers current rotation matrix. We multiply the current attitude with the reference attitude to get the current
    // rotation based on the difference between the two
    CMAttitude *attitude = motionManager.deviceMotion.attitude;
    
    
    //NSLog(@"yaw=%.4f, pitch=%.4f, roll=%.4f", attitude.yaw, attitude.pitch, attitude.roll);
    
    if (referenceAttitude != nil)
        [attitude multiplyByInverseOfAttitude:referenceAttitude];
    CMRotationMatrix rm = attitude.rotationMatrix;
    
    // Create a GLKMatrix4 that we will apply to our models so that they are rendered in relation to where the device is pointing
    GLKMatrix4 deviceMatrix;
    deviceMatrix = GLKMatrix4Make(rm.m11, rm.m21, rm.m31, 0, 
                                  rm.m12, rm.m22, rm.m32, 0,
                                  rm.m13, rm.m23, rm.m33, 0,
                                  0,      0,      0,      1);
    
    
    // Apply rotation to the X and Y axis so that movement of the device is oriented with the OpenGL world coordinates e.g -z is into the screen and +y is up
    deviceMatrix = GLKMatrix4RotateX(deviceMatrix, GLKMathDegreesToRadians(90));
    deviceMatrix = GLKMatrix4RotateY(deviceMatrix, GLKMathDegreesToRadians(-90));
    
    // move around when turning
    //    float currentX = -(sinf(attitude.yaw)  * 250);
    //    float currentZ = -(cosf(attitude.yaw)  * 250);
    //    float currentY = (cosf(attitude.roll)  * 250);
    
    
    //    deviceMatrix = GLKMatrix4Translate(deviceMatrix, currentX, currentY, currentZ);
    
    
    // Multiply our scene and device matrices together. This will cause all objects to then be rendered 
    // based on the rotation of the device giving the appearance that we are looking around inside our
    // 3D world. This is only done if core motion is enabled so we can test on the simulator (without device movement)
    if (coreMotionEnabled) {
        sceneModelMatrix = GLKMatrix4Multiply(sceneModelMatrix, deviceMatrix);
    }
    
    
    
    // Move to the cameras location
    sceneModelMatrix = GLKMatrix4Translate(sceneModelMatrix, camera.position.x, camera.position.y, camera.position.z);
    
    // Update the camera based on the rotation of the device which is now held in the sceneModelMatrix
    [camera updateWithModelMatrix:sceneModelMatrix];
    
    
    
    //    [testObject updateWithDelta:self.timeSinceLastUpdate];
    
    [eventLocations makeObjectsPerformSelector:@selector(updateAllWithDelta:) withObject:[NSNumber numberWithFloat:self.timeSinceLastUpdate]];
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    //    [testObject render];
    
    [eventLocations makeObjectsPerformSelector:@selector(renderAll)];
    
    // We don't need the current contents of the depth buffer in the next frame as we are clearing it
    // so discarding it can provide a small but simple performance boost
    const GLenum discards[]  = {GL_DEPTH_ATTACHMENT};
    glDiscardFramebufferEXT(GL_FRAMEBUFFER, 1, discards);
    
    
    
}

#pragma mark Event Loading

- (void)initEvent {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/events/1" delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    event = (Event*)object;
    [self loadEvent];
}

- (void)loadEvent {
    
    eventLocations = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (EventLocation *location in event.eventLocations) {
        
        //ZN3DEventLocation *l = [[ZN3DEventLocation alloc] initWithEventLocation:location atOrigin:GLKVector3Make(0, 0, i * 50)];
        ZN3DEventLocation *l = [[ZN3DEventLocation alloc] initWithEventLocation:location atOrigin:GLKVector3Make(0, 0, (i * -70) -100) onScene:self];
        [eventLocations addObject:l];
        
        i++;
    }
    
}

@end

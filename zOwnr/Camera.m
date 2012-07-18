//
//  Camera.m
//  GLKit_TD3D
//
// Copyright (c) 2011 71Squared
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

#import "Camera.h"
#import "ZN3DTimelineViewController.h"

#pragma mark - Private Interface

@interface Camera () {
@private
    ZN3DTimelineViewController *sceneController;
    GLKVector3 facingIdentityVector;
}

- (void)initPhysics;

@end

#pragma mark - Public Implementation

@implementation Camera

@synthesize facingVector;
@synthesize fieldOfView;
@synthesize aspectRatio;
@synthesize viewWidth;
@synthesize viewHeight;
@synthesize nearDistance;
@synthesize farDistance;
@synthesize projectionMatrix;

- (id)initWithGameSceneController:(ZN3DTimelineViewController *)aSceneController {
    self = [super init];
    if (self) {
        // Grab a reference to the game scene this camera has been created in
        sceneController = aSceneController;
        
        // Default vector for where the camera is facing e.g. into the screen
        facingIdentityVector = GLKVector3Make(0, 0, -1);
        facingVector = facingIdentityVector;
        
        // The cameras default position is at the origin
        position = GLKVector3Make(0, 0, 0);
        
        // Define the variables that will be used to create the projection matrix
        fieldOfView = GLKMathDegreesToRadians(60.0f);
        viewWidth = sceneController.view.bounds.size.width;
        viewHeight = sceneController.view.bounds.size.height - 200;
        //aspectRatio = viewWidth/viewHeight;
        //aspectRatio = viewHeight/viewWidth;
        aspectRatio = 0.75;
        nearDistance = 5.0f;
        farDistance = 2000.0f;
        
        // Create a 4x4 projection matrix. This will be used by all shaders as their projection matrix
        projectionMatrix = GLKMatrix4MakePerspective(fieldOfView, aspectRatio, nearDistance, farDistance);

        // Initialize the physics object for the camera that will be used for collision detection. In this game
        // the camera is treated as the player
        //[self initPhysics];
        
    }
    return self;
}

- (void)updateWithModelMatrix:(GLKMatrix4)aModelMatrix {
    
    
    
    // Update the facing vector based on the rotation matrix
    aModelMatrix =  GLKMatrix4Invert(aModelMatrix, nil);
    facingVector = GLKVector3Normalize(GLKMatrix4MultiplyVector3(aModelMatrix, facingIdentityVector));
    
}



@end


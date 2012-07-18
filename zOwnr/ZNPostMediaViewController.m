//
//  ZNPostMediaViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNPostMediaViewController.h"
#import "UserMedia.h"
#import "ZNResponseLoader.h"

@implementation ZNPostMediaViewController
@synthesize currentImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (IBAction)doPost:(id)sender {
    
   // UserMedia *um = [[UserMedia alloc] init];
    
    UserMedia *u = [UserMedia createInContext:[[RKObjectManager sharedManager].objectStore managedObjectContextForCurrentThread]];
    
    u.caption = textView.text;
    u.eventItemID = [NSNumber numberWithInt:18];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd hh:mm";
    u.captureTime = [df dateFromString:@"20110917 11:45"];
    ZNResponseLoader *loader = [ZNResponseLoader responseLoader];
    //[[RKObjectManager sharedManager] postObject:u delegate:loader];
    loader.timeout = 40;
    
    NSData *imageData;
    if (imageTaken) {
         imageData = UIImagePNGRepresentation(imageTaken) ;
    }
    
    
    [[RKObjectManager sharedManager] postObject:u usingBlock:^(RKObjectLoader *loader1) {
        
        NSString *dateString = [[RKDotNetDateFormatter dotNetDateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        RKParams* params = [RKParams params];
        [params setValue:u.caption forParam:@"caption"];
        [params setValue:u.eventItemID forParam:@"eventItemID"];
        [params setValue:dateString forParam:@"captureTime"];
        [params setValue:[NSNumber numberWithDouble:attitudeForImageTaken.pitch] forParam:@"pitch"];
        [params setValue:[NSNumber numberWithDouble:attitudeForImageTaken.roll] forParam:@"roll"];
        [params setValue:[NSNumber numberWithDouble:attitudeForImageTaken.yaw] forParam:@"yaw"];
        if (imageData) {
            [params setData:imageData MIMEType:@"image/png" forParam:@"file"];
        }
        loader1.delegate = loader;
        loader1.params = params;
    }];
    
    
    
    //[loader waitForResponse];
    NSLog(@"Current user id is now: %@", u.userMediaID);
    
    

    
//    RKObjectLoader *o = [RKObjectLoader loaderWithURL:@"/usermedia/add" mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    
//    [o setMethod:RKRequestMethodPOST];
//    [o setParams:um];

    
}


- (void)viewDidAppear:(BOOL)animated {
//    [self presentModalViewController:picker animated:NO];
    
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] == NO)
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] == YES)
    {
        // acquire image
            }
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCoreMotion];
    
    
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

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [currentImage setImage:image];
    imageTaken = image;
    attitudeForImageTaken = motionManager.deviceMotion.attitude;
    
    [self dismissModalViewControllerAnimated:YES];
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    imageTaken = [info valueForKey:UIImagePickerControllerOriginalImage];
    [currentImage setImage:imageTaken];
    attitudeForImageTaken = motionManager.deviceMotion.attitude;
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [self setCurrentImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)getImage:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentModalViewController:picker animated:NO];

    
}
@end

//
//  ZNPostMediaViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface ZNPostMediaViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *picker;
    BOOL coreMotionEnabled;
    CMMotionManager *motionManager;
    CMAttitude *referenceAttitude;
    CMAttitude *attitudeForImageTaken;
    IBOutlet UIImageView *currentImage;
    UIImage *imageTaken;
    IBOutlet UITextView *textView;
}
@property (strong, nonatomic) IBOutlet UIImageView *currentImage;

- (IBAction)getImage:(id)sender;
- (void)initCoreMotion;

@end

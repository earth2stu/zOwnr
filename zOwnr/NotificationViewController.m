//
//  NotificationViewController.m
//  zownr
//
//  Created by Stuart Watkins on 15/09/11.
//  Copyright 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import "NotificationViewController.h"
#import "ZNAppDelegate.h"

@implementation NotificationViewController

@synthesize title;
@synthesize label;

- (id)initWithTitle:(NSString*)titleString {
    self = [super initWithNibName:[NSString stringWithString:@"NotificationViewController"] bundle:nil];
    if (self) {
        // Custom initialization
        title = titleString;
        //label.text = titleString;
        
        ZNAppDelegate *z = (ZNAppDelegate*)[[UIApplication sharedApplication] delegate];
//        [z.notifications addObject:self];
        [z.window addSubview:self.view];
        
        //[ownerView.window addSubview:self.view];
        
        //self.view.frame = CGRectMake(0, 380, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = CGRectMake(0, -self.view.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height);
        
        // Fade out the view right away
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //self.view.alpha = 0.5;
                             self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
                             
                         }
                         completion:^(BOOL finished){
                             // Wait one second and then fade in the view
                             [UIView animateWithDuration:0.3
                                                   delay: 1.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  //self.view.alpha = 0.0;
                                                  self.view.frame = CGRectMake(0, -self.view.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  [self.view removeFromSuperview];
//                                                  [z.notifications removeObject:self];
                                              }];
                         }];
        
        
        
                
    }
    return self;

}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [label setText:title];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) showAnimated {
    
}

@end

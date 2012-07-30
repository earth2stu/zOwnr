//
//  ZNTestScrollVC.m
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTestScrollVC.h"


@implementation ZNTestScrollVC

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    NSDate *fromTime = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *toTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
    
    ZNTimelineScrollView2 *c = [[ZNTimelineScrollView2 alloc] initWithFrame:CGRectMake(0, 0, kZNMinTimeMarkerSize * 15, 300)  withDelegate:self];
    [self.view addSubview:c];
    
    
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

- (void)didScrollToTimespan:(NSDate *)fromTime toTime:(NSDate *)toTime {
    NSLog(@"scrolled to :%@ to %@", fromTime, toTime);
}

@end

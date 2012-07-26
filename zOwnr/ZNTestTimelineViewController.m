//
//  ZNTestTimelineViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTestTimelineViewController.h"

@implementation ZNTestTimelineViewController

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

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd HH:00";

    NSDate *f = [df dateFromString:@"20120101 10:00"];
    NSDate *t = [df dateFromString:@"20120101 16:00"];
    
    ZNTimelineScrollView *sv = [[ZNTimelineScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 320) fromTime:f toTime:t withDelegate:self];
    
    [self.view addSubview:sv];
    
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didScrollToTimespan:(NSDate *)fromTime toTime:(NSDate *)toTime {
    NSLog(@"** scrolled to %@ to %@", fromTime, toTime);
}

@end

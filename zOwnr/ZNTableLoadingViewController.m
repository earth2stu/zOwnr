//
//  ZNTableLoadingViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 10/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTableLoadingViewController.h"

@implementation ZNTableLoadingViewController

//@synthesize delegate;
@synthesize label;
@synthesize labelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id<ZNLoadingViewDelegate>)delegate andMessage:(NSString*)message
{
    
    self = [super initWithNibName:@"ZNTableLoadingViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
        _delegate = delegate;
        labelText = message;
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
    label.text = labelText;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)cancelWaiting {
    [self.view removeFromSuperview];
    //[_delegate performSelector:@selector(cancelWaiting)];
    [_delegate cancel];
}

-(void)close {
    [self.view removeFromSuperview];
}


@end

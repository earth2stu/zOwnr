//
//  EventItemViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 10/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventItemViewController.h"

@implementation EventItemViewController

@synthesize eventItem;
@synthesize fromFrame;

/*
- (id)initWithEventItem:(EventItem*)theEventItem {
    self = [super init];
    if (self) {
        // Custom initialization
        eventItem = theEventItem;
        
    }
    return self;
}
*/

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
    
 //   mainView.frame = fromFrame;
    
 //   [UIView animateWithDuration:0.5 animations:^{
 //       mainView.frame = CGRectMake(20, 20, 280, 200);
 //   }];
    
    //titleLabel.text = eventItem.name;
    
    
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touched");
}


@end

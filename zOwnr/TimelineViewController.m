//
//  TimelineViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "TimelineViewController.h"
#import "EventLocationTimelineView.h"
#import "EventItemViewController.h"

@implementation TimelineViewController

@synthesize event;

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
    
    timelineScroll.contentSize = CGSizeMake(1000, 400);
    
//    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/events/1" usingBlock:^(RKObjectLoader *loader) {
//        NSArray *results = [loader result].asCollection;
//        NSLog(@"got results");
//    }];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/events/1" delegate:self];
    
    
    /*
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    RKURL *URL = [RKURL URLWithString:@"http://api2.zownr.com/events/1"];

    
    
    RKManagedObjectLoader *objectLoader = [RKManagedObjectLoader loaderWithURL:URL mappingProvider:objectManager.mappingProvider objectStore:objectManager.objectStore];
    objectLoader.delegate = self;
    
    
    [objectLoader send];
    
    */
    
    // load the event
    
    //[[ZownrService sharedInstance] getEventByID:[NSNumber numberWithInt:1] completion:^(Event *theEvent, NSError *error) {
    //    self.event = theEvent;
    //    [self initEvent];
    //}];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    event = (Event*)object;
    
    /*
    //[event release];
    NSFetchRequest* request = [Event fetchRequest];
    //NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    [request setPredicate:[NSPredicate predicateWithFormat:@"eventID = %@", event.eventID]];
    //[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSArray *events = [Event objectsWithFetchRequest:request];
    event = [events objectAtIndex:0];
    */
    
    NSLog(@"got event: %@", event.name);
    [self initEvent];
    
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"error");
}


- (void)initEvent {
    
    t = [[TimelineView alloc] initWithEvent:event frame:CGRectMake(0, 0, 1000, 400)];
    t.delegate = self;
    [timelineScroll addSubview:t];
    [t didScroll:timelineScroll];
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

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"did zoom");
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [t didScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [t didScroll:scrollView];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return t;
}

- (void)selectEventItem:(EventItem *)e fromFrame:(CGRect)fromFrame {
    EventItemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventItem"];
    vc.eventItem = e;
    vc.fromFrame = fromFrame;
    vc.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentModalViewController:vc animated:YES];
    //[self.navigationController pushViewController:vc animated:NO];
}

@end

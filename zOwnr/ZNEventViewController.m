//
//  ZNEventViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 17/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNEventViewController.h"

@implementation ZNEventViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    eventScroll.contentSize = CGSizeMake(960, 640);
    timelineScroll.contentSize = CGSizeMake(1000, 400);
    quadrantView.delegate = self;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/events/1" delegate:self];
    
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

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    event = (Event*)object;
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
    
    /*
    
    EventItemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventItem"];
    vc.eventItem = e;
    vc.fromFrame = fromFrame;
    vc.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentModalViewController:vc animated:YES];
    //[self.navigationController pushViewController:vc animated:NO];
     
     */
}

#pragma mark QuadrantDelegate

- (void)didMoveToPoint:(float)point onEdge:(kQuadrantEdge)edge {
    switch (edge) {
        case kQuadrantEdgeRight:
            // switching between map and timeline
            
            //[timelineScroll setFrame:CGRectMake(0, point, timelineScroll.frame.size.width, 320.0f - point)];
            //[mapView setFrame:CGRectMake(0, 0, 435, point)];
            
            
            break;
            
        default:
            break;
    }
}

- (void)didSwitchToCorner:(kQuadrantCorner)corner {
    
    [UIView animateWithDuration:0.25 animations:^{
        switch (corner) {
            case kQuadrantCornerBottomRight:
                // main map view
                
                [mapView setFrame:CGRectMake(0, 0, 435, 275)];
                [timelineScroll setFrame:CGRectMake(0, 275, 435, 45)];
                
                break;
                
            case kQuadrantCornerTopRight:
                // main map view
                
                [mapView setFrame:CGRectMake(0, 0, 435, 45)];
                [timelineScroll setFrame:CGRectMake(0, 45, 435, 275)];
                
                break;
                
            case kQuadrantCornerBottomLeft:
                // main map view
                
                [mapView setFrame:CGRectMake(0, 0, 45, 275)];
                [timelineScroll setFrame:CGRectMake(0, 275, 0, 45)];
                
                break;
                
            case kQuadrantCornerTopLeft:
                // main map view
                
                [mapView setFrame:CGRectMake(0, 0, 0, 0)];
                [timelineScroll setFrame:CGRectMake(0, 45, 45, 275)];
                
                break;
                
            default:
                break;
        }

    } completion:^(BOOL finished) {
        switch (corner) {
            case kQuadrantCornerBottomRight:
                // main map view
                
                
                break;
                
            case kQuadrantCornerTopRight:
                // main map view
                
                
                break;
                
            case kQuadrantCornerBottomLeft:
                // main map view
                
                                break;
                
            case kQuadrantCornerTopLeft:
                // main map view
                
                
                break;
                
            default:
                break;
        }

    }]; 
    
    [UIView beginAnimations:@"FinalScroll" context:nil];
    
        
    [UIView commitAnimations];
    
    return;
}



@end

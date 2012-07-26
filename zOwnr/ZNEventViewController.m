//
//  ZNEventViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 17/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//


#import "ZNEventViewController.h"
#import "Event.h"
#import "EventLocation.h"
#import "EventLocationAnnotation.h"
#import "EventAnnotationView.h"
#import "UserMedia.h"
#import "UserMediaAnnotation.h"

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
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/eventItems/18/usermedia" delegate:self];
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

/*
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    
    if ([objectLoader.resourcePath isEqualToString:@"/events/1"]) {
        event = (Event*)object;
        NSLog(@"got event: %@", event.name);
        [self initEvent];
    } else {
        // assuming the 
        
        
        
    }
    
    
    
}
 */


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    if ([objectLoader.resourcePath isEqualToString:@"/events/1"]) {
        event = (Event*)[objects objectAtIndex:0];;
        NSLog(@"got event: %@", event.name);
        [self initEvent];
    } else {
        // assuming the 
        
        for (UserMedia *um in objects) {
            UserMediaAnnotation *v = [[UserMediaAnnotation alloc] initWithUserMedia:um];
            [mapView addAnnotation:v];
        }

        
    }

    
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"error");
}


- (void)initEvent {
    
    t = [[TimelineView alloc] initWithEvent:event frame:CGRectMake(0, 0, 1000, 400)];
    t.delegate = self;
    [timelineScroll addSubview:t];
    [t didScroll:timelineScroll];
    
    for (EventLocation *l in event.eventLocations) {
        //
        EventLocationAnnotation *ann = [[EventLocationAnnotation alloc] initWithLocation:l];
        [mapView addAnnotation:ann];
    }
    
    CLLocationCoordinate2D coordinateOrigin = CLLocationCoordinate2DMake([event.latitudeNW doubleValue], [event.longitudeNW doubleValue]);
    CLLocationCoordinate2D coordinateMax = CLLocationCoordinate2DMake([event.latitudeSE doubleValue], [event.longitudeSE doubleValue]);
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(coordinateOrigin);
    MKMapPoint lowerRight = MKMapPointForCoordinate(coordinateMax);
    
    MKMapRect mapRect = MKMapRectMake(upperLeft.x,
                                      upperLeft.y,
                                      lowerRight.x - upperLeft.x,
                                      lowerRight.y - upperLeft.y);
    
    
    [mapView setVisibleMapRect:mapRect animated:YES];
    
    mapView.showsUserLocation = YES;
}



- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    /*
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[PersonAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapview dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    */
    
    if ([annotation isKindOfClass:[EventLocationAnnotation class]]) {
        EventLocationAnnotation *fa = (EventLocationAnnotation*)annotation;
        EventLocation *f = fa.location;
        
        EventAnnotationView *av = [[EventAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
        
        
        //MKAnnotationView *av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"stage"];
        //UIImage *icon = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/facility_%@.png", [[NSBundle mainBundle] bundlePath], @"stage"]];
        //UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        //[av addSubview:iconView];
        av.canShowCallout = YES;
        return av;
    }
    
    if ([annotation isKindOfClass:[UserMediaAnnotation class]]) {
        //UserMediaAnnotation *fa = (UserMediaAnnotation*)annotation;
        //UserMedia *m = fa.userMedia;
        
        EventAnnotationView *av = [[EventAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"media"];
        
        
        //MKAnnotationView *av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"stage"];
        //UIImage *icon = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/facility_%@.png", [[NSBundle mainBundle] bundlePath], @"stage"]];
        //UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        //[av addSubview:iconView];
        av.canShowCallout = YES;
        return av;
    }
    
    
    
    
    return nil;
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

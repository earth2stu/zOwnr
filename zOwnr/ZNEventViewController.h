//
//  ZNEventViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 17/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TimelineView.h"
#import "Event.h"
#import "ZownrService.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

#import "ZNQuadrantView.h"


@interface ZNEventViewController : UIViewController <UIScrollViewDelegate, RKObjectLoaderDelegate, TimelineDelegate, MKMapViewDelegate, QuadrantDelegate>  {
    IBOutlet UIScrollView *timelineScroll;
    IBOutlet UIScrollView *eventScroll;
    
    IBOutlet ZNQuadrantView *quadrantView;
    
    IBOutlet MKMapView *mapView;
    
    TimelineView *t;
    Event *event;
}

@property (nonatomic, strong) Event *event;
- (void)initEvent;


@end

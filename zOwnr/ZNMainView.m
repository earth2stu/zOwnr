//
//  ZNMainView.m
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMainView.h"

@implementation ZNMainView

@synthesize timelineView, socialView, mapView, mediaView;

- (id)initWithFrame:(CGRect)frame withDelegate:(id<ZNMainViewDelegate>)del
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        delegate = del;
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        //[self setCurrentQuadrant:kQuadrantCornerDefault];
        
        mapView = [[ZNMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withDelegate:self];
        [self addSubview:mapView];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyyMMdd HH:mm";
        
        NSDate *fromTime = [df dateFromString:@"20110910 12:00"];
        NSDate *toTime = [df dateFromString:@"20110920 12:00"];
        
        
        //NSDate *fromTime = [NSDate dateWithTimeIntervalSinceNow:-(4 * 3600 * 24)];
        //NSDate *toTime = [NSDate dateWithTimeIntervalSinceNow:(4 * 3600 * 24)];

        
        //timelineView = [[ZNTimelineScrollView alloc] initWithFrame:CGRectMake(0, 0, 435, 275) fromTime:fromTime toTime:toTime withDelegate:self];
        //[self addSubview:timelineView];
        
        timelineView = [[ZNTimelineScrollView2 alloc] initWithFrame:CGRectMake(0, 0, 435, 275) withDelegate:self];
        [timelineView setTimespanFrom:fromTime to:toTime];
        [self addSubview:timelineView];
        
        socialView = [[ZNSocialView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:socialView];
        
        mediaView = [[ZNMediaView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:mediaView];
        
        [delegate setCurrentMainView:mapView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setCurrentQuadrant:currentQuadrant];
}

#pragma mark MapViewDelegate

- (void)didSelectAnnotation:(id<MKAnnotation>)annotation {
    
}

- (void)setCurrentQuadrant:(kQuadrantCorner)quadrant {
    currentQuadrant = quadrant;
    
    [UIView animateWithDuration:0.25 animations:^{
        switch (quadrant) {
            case kQuadrantCornerTopLeft:
                // main map view
                
                [mapView setFrame:CGRectMake(0, 0, self.frame.size.width - kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                [timelineView setFrame:CGRectMake(0, self.frame.size.height - kMainEdgeViewHeight, self.frame.size.width - kMainEdgeViewHeight, kMainEdgeViewHeight)];
                [socialView setFrame:CGRectMake(self.frame.size.width - kMainEdgeViewHeight, 0, kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                [mediaView setFrame:CGRectMake(self.frame.size.width, self.frame.size.height, 0, 0)];
                
                [delegate setCurrentMainView:mapView];
                
                break;
                
            case kQuadrantCornerBottomLeft:
                // main timeline view
                
                [mapView setFrame:CGRectMake(0, 0, self.frame.size.width - kMainEdgeViewHeight, kMainEdgeViewHeight)];
                [timelineView setFrame:CGRectMake(0, kMainEdgeViewHeight, self.frame.size.width - kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                [socialView setFrame:CGRectMake(self.frame.size.width, 0, 0, 0)];
                [mediaView setFrame:CGRectMake(self.frame.size.width - kMainEdgeViewHeight, kMainEdgeViewHeight, kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                
                [delegate setCurrentMainView:timelineView];
                
                break;
                
            case kQuadrantCornerTopRight:
                // main social view
                
                [mapView setFrame:CGRectMake(0, 0, kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                [timelineView setFrame:CGRectMake(0, self.frame.size.height, 0, 0)];
                [socialView setFrame:CGRectMake(kMainEdgeViewHeight, 0, self.frame.size.width - kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                [mediaView setFrame:CGRectMake(kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight, self.frame.size.width - kMainEdgeViewHeight, kMainEdgeViewHeight)];
                
                [delegate setCurrentMainView:socialView];
                
                break;
                
            case kQuadrantCornerBottomRight:
                // main media view
                
                [mapView setFrame:CGRectMake(0, 0, 0, 0)];
                [timelineView setFrame:CGRectMake(0, kMainEdgeViewHeight, kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                [socialView setFrame:CGRectMake(kMainEdgeViewHeight, 0, self.frame.size.width - kMainEdgeViewHeight, kMainEdgeViewHeight)];
                [mediaView setFrame:CGRectMake(kMainEdgeViewHeight, kMainEdgeViewHeight, self.frame.size.width - kMainEdgeViewHeight, self.frame.size.height - kMainEdgeViewHeight)];
                
                [delegate setCurrentMainView:mediaView];
                
                break;
                
            default:
                break;
        }
        
    } completion:^(BOOL finished) {
        switch (quadrant) {
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
}

#pragma mark TimelineScrollDelegate

- (void)didScrollToTimespan:(NSDate *)fromTime toTime:(NSDate *)toTime {
    NSLog(@"scrolled to time %@ to %@", fromTime, toTime);
    if (!currentZone) {
        currentZone = [[Zone alloc] init];
    }
    currentZone.fromTime = fromTime;
    currentZone.toTime = toTime;
    return;
}

#pragma mark MapViewDelegate

- (void)openMenuFor:(id<ZNMenuView>)sender {
    [delegate openMenuFor:sender];
}

- (void)didScrollToRegion:(CLLocationCoordinate2D)pointNW pointSE:(CLLocationCoordinate2D)pointSE {
    NSLog(@"scrolled to region %f", pointNW.longitude);
    if (!currentZone) {
        currentZone = [[Zone alloc] init];
    }
    currentZone.pointNW = pointNW;
    currentZone.pointSE = pointSE;
    return;

}

- (Zone*)getCurrentZone {
    return currentZone;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

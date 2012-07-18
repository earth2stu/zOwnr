//
//  TimelineView.h
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventLocation.h"
#import "EventLocationTimelineView.h"
#import "CurrentTimeView.h"

// layout parameters

#define kTLinitialWidth 480;
//#define kTLtopMargin 30;


@protocol TimelineDelegate <NSObject>

- (void)selectEventItem:(EventItem*)e fromFrame:(CGRect)fromFrame;

@end

@interface TimelineView : UIView <EventLocationDelegate> {
    Event *event;
    UIPinchGestureRecognizer *pinchRecognizer;
    float initialSize;
    
    
    // time markers
    NSDate *startTime;
    NSDate *endTime;
    int totalHours;
    NSMutableArray *timeMarkerViews;
    CurrentTimeView *currentTimeView;
    
    NSNumber *pixelsPerHour;
    
    // locations
    NSMutableArray *locationViews;
    
    
}

@property (nonatomic, retain) id<TimelineDelegate> delegate;

- (id)initWithEvent:(Event*)theEvent frame:(CGRect)frame;
- (void)updateTimeMarkers;
- (void)didScroll:(UIScrollView*)scrollView;
- (void)setLocationFrames;

@end

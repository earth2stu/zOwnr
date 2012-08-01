//
//  ZNTimelineScrollView2.h
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNTimeMarkerView.h"
#import "Zone.h"
#import "ZNMenuView.h"
#import "ZNMainBaseView.h"
#import "ZNTimelineContentView.h"

static const float kZNMinTimeMarkerSize = 20.0f;
static const float kZNRowHeight = 45.0f;

@protocol ZNTimelineView;

@protocol ZNTimelineScrollDelegate <NSObject>

- (void)didScrollToTimespan:(NSDate*)fromTime toTime:(NSDate *)toTime;


@end

@interface ZNTimelineScrollView : UIScrollView <UIScrollViewDelegate> {
    
    // markers
    NSMutableArray *timeMarkers;
    float currentMarkerWidth;
    kZNTimelineMarkerMode currentMarkerMode;
    
    float minMarkerWidth;
    int maxMarkers;
    
    //float maxMarkerWidth;
    //UIEdgeInsets responseInsets;
    
    // main content view
    ZNTimelineContentView *contentView;
    
    // pinch
    UIPinchGestureRecognizer *pinchRecognizer;
    float initialPinchMarkerSize;
    float initialPinchScaleFactor;
    BOOL isZooming;
    
    // time
    NSDate *currentZeroTime;
    
    // labels
    UILabel *leftStaticTime;
    UILabel *rightStaticTime;
    
    // delegate
    id<ZNTimelineScrollDelegate> scrollDelegate;
    
    // currently held root object
    id<ZNTimelineView> currentObject;
    
    BOOL isUpdatingFromUserGesture;
    
}

@property (assign) UIEdgeInsets responseInsets;
@property (nonatomic, retain) NSDate *minTime;
@property (nonatomic, retain) NSDate *maxTime;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

- (id)initWithFrame:(CGRect)frame withDelegate:(id<ZNTimelineScrollDelegate>)del;
- (void)setTimespanFrom:(NSDate*)fromTime to:(NSDate*)toTime;
- (void)setCurrentObject:(id<ZNTimelineView>)object;

//- (id)initWithSuperFrame:(CGRect)superFrame;

@end

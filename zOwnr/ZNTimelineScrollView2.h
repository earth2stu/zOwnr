//
//  ZNTimelineScrollView2.h
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNTimeMarkerView.h"

static const float kZNMinTimeMarkerSize = 20.0f;



@interface ZNTimelineScrollView2 : UIScrollView <UIScrollViewDelegate> {
    NSMutableArray *timeMarkers;
    float currentMarkerWidth;
    kZNTimelineMarkerMode currentMarkerMode;
    float maxMarkerWidth;
    UIEdgeInsets responseInsets;
    UIPinchGestureRecognizer *pinchRecognizer;
    float initialPinchMarkerSize;
    float initialPinchScaleFactor;
    
    BOOL isZooming;
}

@property (assign) UIEdgeInsets responseInsets;
@property (nonatomic, retain) NSDate *minTime;
@property (nonatomic, retain) NSDate *maxTime;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

//- (id)initWithSuperFrame:(CGRect)superFrame;

@end

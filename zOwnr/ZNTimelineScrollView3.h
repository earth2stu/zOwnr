//
//  ZNTimelineScrollView.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNTimelineView.h"
#import "Zone.h"
#import "ZNMenuView.h"
#import "ZNMainBaseView.h"

@protocol ZNTimelineViewOld <NSObject>

- (NSArray*)rows;
- (NSDate*)startTime;
- (NSDate*)endTime;

@end

@protocol TimelineScrollDelegate <NSObject>

- (void)didScrollToTimespan:(NSDate*)fromTime toTime:(NSDate *)toTime;
- (Zone*)getCurrentZone;

@end

@interface ZNTimelineScrollView3 : ZNMainBaseView <UIScrollViewDelegate, TimelineDelegate, ZNMenuView> {
    UIScrollView *timelineScrollView;
    ZNTimelineView *t;
    id<ZNTimelineViewOld> timelineObject;
    
    
    
    float timelineCentre;
}

- (id)initWithDelegate:(id<TimelineScrollDelegate>)delegate;
- (id)initWithFrame:(CGRect)frame fromTime:(NSDate*)fromTime toTime:(NSDate*)toTime withDelegate:(id<TimelineScrollDelegate>)delegate;
- (void)setTimelineObject:(id<ZNTimelineViewOld>)timelineObj;

@end

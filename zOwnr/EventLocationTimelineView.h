//
//  EventLocationTimelineView.h
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventLocation.h"
#import "EventItemTimelineView.h"



@class EventLocationTimelineView;

@protocol EventLocationDelegate <NSObject>

- (void)selectEventLocation:(EventLocation*)l fromFrame:(CGRect)fromFrame;
- (void)selectEventItem:(EventItem*)e fromFrame:(CGRect)fromFrame inLocationView:(EventLocationTimelineView*)locationView;

@end

@interface EventLocationTimelineView : UIView <EventItemDelegate> {
    EventLocation *location;
    UILabel *nameLabel;
    NSMutableArray *itemViews;
    NSNumber *pixelsPerHour;
    NSDate *startTime;
    BOOL isSelected;
    int index;
}

@property (assign) BOOL isSelected;
@property (assign) int index;

@property (nonatomic, retain) id<EventLocationDelegate> delegate;


- (id)initWithLocation:(EventLocation*)theLocation frame:(CGRect)frame pixelsPerHour:(NSNumber*)pph startTime:(NSDate*)sTime;
- (void)updatePixelsPerHour:(NSNumber*)pph;
- (void)didScroll:(UIScrollView*)scrollView;
- (void)deselect;
- (void)reapplyRecognizers;

@end


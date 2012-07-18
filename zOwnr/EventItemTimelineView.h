//
//  EventItemTimelineView.h
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventItem.h"
#import "EventLocation.h"
#import "Event.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "EventItemView.h"

@protocol EventItemDelegate <NSObject>

- (void)selectEventItem:(EventItem*)e fromFrame:(CGRect)fromFrame;

@end

@interface EventItemTimelineView : UIView <RKObjectLoaderDelegate,UIGestureRecognizerDelegate> {
    EventItem *item;
    NSNumber *pixelsPerHour;
    NSDate *startTime;
    UILabel *titleLabel;
    UIButton *eventItemButton;
    BOOL mediaIsLoaded;
    CGRect visibleFrame;
    NSMutableArray *userMediaViews;
    UITapGestureRecognizer *tap;
    UIButton *tickButton;
}

@property (nonatomic, retain) id<EventItemDelegate> delegate;



- (id)initWithEventItem:(EventItem*)theItem pixelsPerHour:(NSNumber*)pph startTime:(NSDate*)sTime;
- (void)setCurrentFrame:(NSNumber*)pph;


- (void)didScroll:(UIScrollView*)scrollView;
- (void)reloadMedia;
- (void)reapplyRecognizers;
@end

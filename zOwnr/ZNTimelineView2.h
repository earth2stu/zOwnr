//
//  ZNTimelineView.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNTimelineBarView.h"

@protocol TimelineCell;
@protocol TimelineRow;



@protocol TimelineDelegate <NSObject>

- (void)selectRow:(id<TimelineRow>)row;
- (void)selectCell:(id<TimelineCell>)cell;
- (void)didScrollToTimespan;
- (void)startUpdatingSize;
- (void)didUpdateSize;


@end

@interface ZNTimelineView : UIView {
    id<TimelineDelegate> delegate;
    ZNTimelineBar *bar;
    UIPinchGestureRecognizer *pinchRecognizer;
    NSNumber *pixelsPerHour;
    float totalHours;
    
    NSDate* fromTime;
    NSDate* toTime;
    
    // initial frame width when scrolling begins
    float initialSize;
}

@property (nonatomic, retain) NSNumber *pixelsPerHour;
@property (nonatomic, retain) NSDate *fromTime;
@property (nonatomic, retain) NSDate *toTime;

//- (id)initWithEvent:(Event*)theEvent frame:(CGRect)frame;
- (void)didScroll:(UIScrollView*)scrollView;
//- (void)setLocationFrames;
- (id)initWithFrame:(CGRect)frame fromTime:(NSDate*)initialFromTime toTime:(NSDate*)initialToTime delegate:(id<TimelineDelegate>)delegate;

@end

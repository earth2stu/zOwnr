//
//  ZNTimeMarkerView.h
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kZNTimelineMarkerModeHour,
    kZNTimelineMarkerModeQuarterDay,
    kZNTimelineMarkerModeHalfDay,
    kZNTimelineMarkerModeDay,
    kZNTimelineMarkerModeMonth
} kZNTimelineMarkerMode;

@interface ZNTimeMarkerView : UIView {
    UILabel *label;
    int currentIndex;
    NSDate *zeroTime;
    kZNTimelineMarkerMode currentMode;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)index zeroTime:(NSDate*)zTime;

- (void)setNewIndex:(int)index;
- (NSString*)labelForCurrentTime;
- (void)setMarkerMode:(kZNTimelineMarkerMode)mode;

@end

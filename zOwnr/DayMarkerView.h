//
//  DayMarkerView.h
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayMarkerView : UIView {
    NSDate *time;
    NSDate *startTime;
    NSNumber *pixelsPerHour;
    int hoursOffset;
}

- (id)initWithTime:(NSDate*)theTime startTime:(NSDate*)theStartTime pixelsPerHour:(NSNumber*)pph;
- (id)initWithTime:(NSString*)theTime frame:(CGRect)frame;
- (void)setCurrentFrame:(NSNumber*)pph;
- (void)hideMarker;

@end

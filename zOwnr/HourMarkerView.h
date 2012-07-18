//
//  HourMarkerView.h
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourMarkerView : UIView {
    NSDate *time;
    NSDate *startTime;
    NSNumber *pixelsPerHour;
    int hoursOffset;
}

- (id)initWithTime:(NSDate*)theTime startTime:(NSDate*)theStartTime pixelsPerHour:(NSNumber*)pph;
- (id)initWithTime:(NSString*)theTime frame:(CGRect)frame;
- (void)setCurrentFrame:(NSNumber*)pph;

@end

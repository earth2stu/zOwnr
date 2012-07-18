//
//  CurrentTimeView.h
//  zOwnr
//
//  Created by Stuart Watkins on 14/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentTimeView : UIView {
    NSNumber *pixelsPerHour;
    NSTimer *timer;
    NSDate *startTime;
}

- (void)setCurrentFrame:(NSNumber*)pph;
- (id)initWithPixelsPerHour:(NSNumber*)pph startTime:(NSDate*)theStartTime;

@end

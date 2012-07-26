//
//  ZNTimelineBar.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

// hour markers
// day markers
// month markers??


static const int kTLMinMarkerWidth = 50; // minimum width for a marker view



@interface ZNTimelineBar : UIView {


}

- (void)updatePixelsPerHour:(NSNumber*)pixelsPerHour fromTime:(NSDate*)startTime toTime:(NSDate*)endTime;

@end

//
//  ZNTimeMarkerView.m
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimeMarkerView.h"

@implementation ZNTimeMarkerView

- (id)initWithFrame:(CGRect)frame andIndex:(int)index zeroTime:(NSDate *)zTime
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        zeroTime = zTime;
        currentIndex = index;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.text = [NSString stringWithFormat:@"%i", index];
        [self addSubview:label];
    }
    return self;
}

- (void)setNewIndex:(int)index {
    currentIndex = currentIndex + index;
    //label.text = [NSString stringWithFormat:@"%i", currentIndex];
    label.text = [self labelForCurrentTime];
}

- (void)setMarkerMode:(kZNTimelineMarkerMode)mode {
    currentMode = mode;
    label.text = [self labelForCurrentTime];
}

- (NSString*)labelForCurrentTime {
    
    NSDate *currentTime;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    switch (currentMode) {
        case kZNTimelineMarkerModeHour:
            currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600)];
            df.dateFormat = @"HH";
            break;
            
        case kZNTimelineMarkerModeQuarterDay:
            currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600 * 6)];
            df.dateFormat = @"dd";
            break;
            
        case kZNTimelineMarkerModeHalfDay:
            currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600 * 6 * 2)];
            df.dateFormat = @"dd";
            break;
            
        case kZNTimelineMarkerModeDay:
            currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600 * 6 * 2 * 2)];
            df.dateFormat = @"dd";
            break;
            
        default:
            break;
    }

    
    
    //NSDate *currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600)];
    
    
    return [df stringFromDate:currentTime];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

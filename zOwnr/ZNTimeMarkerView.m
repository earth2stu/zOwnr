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

- (NSString*)labelForCurrentTime {
    NSDate *currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH";
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

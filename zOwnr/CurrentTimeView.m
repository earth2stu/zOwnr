//
//  CurrentTimeView.m
//  zOwnr
//
//  Created by Stuart Watkins on 14/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "CurrentTimeView.h"

@implementation CurrentTimeView

- (id)initWithPixelsPerHour:(NSNumber*)pph startTime:(NSDate*)theStartTime {
    self = [super init];
    if (self) {
        // Initialization code
        pixelsPerHour = pph;
        startTime = theStartTime;
        self.alpha = 0.5;
        [self setCurrentFrame:pph];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateFromTimer:) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateFromTimer:(NSTimer*)theTimer {
    [self setCurrentFrame:pixelsPerHour];
}

- (void)setCurrentFrame:(NSNumber*)pph {
    
    pixelsPerHour = pph;
    
    
    // testing time
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *rightNow = [f dateFromString:@"2011-09-17 11:37"];
    
    
    //NSDate *rightNow = [NSDate dateWithTimeIntervalSinceNow:0];
    float hoursOffset = [rightNow timeIntervalSinceDate:startTime] / 3600;
    self.frame = CGRectMake(hoursOffset * [pixelsPerHour floatValue], 0, 4, self.superview.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1); //there are two relevant color states, "Stroke" -- used in Stroke drawing functions and "Fill" - used in fill drawing functions
    
    //now we build a "path"
    CGContextSetLineWidth(ctx, 4.0f);
    //you can either directly build it on the context or build a path object, here I build it on the context
    CGContextMoveToPoint(ctx, 0, 0);
    //add a line from 0,0 to the point 100,100
    CGContextAddLineToPoint( ctx, 0,self.frame.size.height);
    
    CGContextStrokePath(ctx);
    
    
    
}


@end

//
//  HourMarkerView.m
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "HourMarkerView.h"

@implementation HourMarkerView

- (id)initWithTime:(NSDate*)theTime startTime:(NSDate*)theStartTime pixelsPerHour:(NSNumber*)pph {
    self = [super init];
    if (self) {

        time = theTime;
        startTime = theStartTime;
        
        hoursOffset = [theTime timeIntervalSinceDate:startTime] / 3600;
        pixelsPerHour = pph;

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"ha";
        NSString *timeString = [df stringFromDate:time];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        timeLabel.text = timeString;
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];

        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        self.alpha = 0.5;
        
        self.contentMode = UIViewContentModeRedraw;
        
        [self setCurrentFrame:pixelsPerHour];
        
    }
    return self;
}

- (void)setCurrentFrame:(NSNumber*)pph {
    pixelsPerHour = pph;
    self.frame = CGRectMake((hoursOffset * [pixelsPerHour floatValue]) + kTLleftMargin, 0,[pixelsPerHour floatValue] - 3, self.superview.frame.size.height);

}

/*
- (id)initWithTime:(NSString*)theTime frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        date = theTime;
        
        NSLog(@"adding hour marker");
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        timeLabel.text = date;
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        
        self.alpha = 0.5;

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

*/


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self setHidden:NO];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1); //there are two relevant color states, "Stroke" -- used in Stroke drawing functions and "Fill" - used in fill drawing functions
    
    
    //now we build a "path"
    CGContextSetLineWidth(ctx, 1.0f);
    
    //you can either directly build it on the context or build a path object, here I build it on the context
    //CGContextMoveToPoint(ctx, 0, 0);
    //add a line from 0,0 to the point 100,100
    //CGContextAddLineToPoint( ctx, 0,self.frame.size.height);
    
     //CGContextStrokePath(ctx);
    
    /*
    // add half hour line
    CGContextMoveToPoint(ctx, 0.5 * [pixelsPerHour intValue], self.frame.size.height * 0.5);
    CGContextAddLineToPoint(ctx, 0.5 * [pixelsPerHour intValue], self.frame.size.height);
    CGContextStrokePath(ctx);
    
    if ([pixelsPerHour floatValue] >= 120) {
        // add first quarter hour line
        CGContextMoveToPoint(ctx, 0.25 * [pixelsPerHour intValue], self.frame.size.height * 0.6);
        CGContextAddLineToPoint(ctx, 0.25 * [pixelsPerHour intValue], self.frame.size.height);
        CGContextStrokePath(ctx);
        
        // add second quarter hour line
        CGContextMoveToPoint(ctx, 0.75 * [pixelsPerHour intValue], self.frame.size.height * 0.6);
        CGContextAddLineToPoint(ctx, 0.75 * [pixelsPerHour intValue], self.frame.size.height);
        CGContextStrokePath(ctx);

    }
    */
    float pixelsForFiveMins = [pixelsPerHour floatValue] / 12;
    
    //if ([pixelsPerHour floatValue] >= 240) {
        // add first quarter hour line
        
    for (int i = 1; i <= 12; i++) {
        
        float startPoint;
        BOOL showLine;
        
        if (i == 6) {
            // half hour line
            startPoint = self.frame.size.height * 0.5;
            showLine = YES;
            CGContextSetLineWidth(ctx, 3.0f);

        } else if (i == 3 || i == 9) {
            startPoint = self.frame.size.height * 0.6;
            showLine = ([pixelsPerHour floatValue] >= 120);
            CGContextSetLineWidth(ctx, 2.0f);

        } else {
            startPoint = self.frame.size.height * 0.7;
            showLine = ([pixelsPerHour floatValue] >= 240);
            CGContextSetLineWidth(ctx, 1.0f);

        }
        
        if (showLine) {
            CGContextMoveToPoint(ctx, i * pixelsForFiveMins, startPoint);
            CGContextAddLineToPoint(ctx, i * pixelsForFiveMins, self.frame.size.height);
            CGContextStrokePath(ctx);

        }
    }
        
                
        
    //}

        
    
    
}

- (void)hideMarker {
    [self setHidden:YES];
}



@end

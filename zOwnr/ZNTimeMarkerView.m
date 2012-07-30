//
//  ZNTimeMarkerView.m
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimeMarkerView.h"

@implementation ZNTimeMarkerView

@synthesize currentTime = _currentTime;

- (id)initWithIndex:(int)index {
    self = [super init];
    if (self) {
        
        currentIndex = index;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.font = [UIFont systemFontOfSize:10];
        label.text = [NSString stringWithFormat:@"%i", index];
        [self addSubview:label];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIndex:(int)index zeroTime:(NSDate *)zTime
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        zeroTime = zTime;
        currentIndex = index;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.font = [UIFont systemFontOfSize:10];
        label.text = [NSString stringWithFormat:@"%i", index];
        [self addSubview:label];
        
        self.backgroundColor = [UIColor whiteColor];
        
        //indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 50, 20)];
        //indexLabel.text = [NSString stringWithFormat:@"%i", index];
        //[self addSubview:indexLabel];
    }
    return self;
}

- (void)setNewIndex:(int)index {
    currentIndex = currentIndex + index;
    //indexLabel.text = [NSString stringWithFormat:@"%i", currentIndex];
    label.text = [self labelForCurrentTime];
}

- (void)setMarkerMode:(kZNTimelineMarkerMode)mode {
    currentMode = mode;
    label.text = [self labelForCurrentTime];
}

- (void)setNewZeroTime:(NSDate *)zTime {
    zeroTime = zTime;
    label.text = [self labelForCurrentTime];

}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [label setFrame:CGRectMake(0, 0, frame.size.width - 2, 20)];
}

- (NSString*)labelForCurrentTime {
    
    //NSDate *currentTime;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    switch (currentMode) {
        case kZNTimelineMarkerModeHour:
            _currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600)];
            df.dateFormat = @"HH";
            break;
            
        case kZNTimelineMarkerModeQuarterDay:
            _currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600 * 6)];
            df.dateFormat = @"dd";
            break;
            
        case kZNTimelineMarkerModeHalfDay:
            _currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600 * 6 * 2)];
            df.dateFormat = @"dd";
            break;
            
        case kZNTimelineMarkerModeDay:
            _currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600 * 6 * 2 * 2)];
            df.dateFormat = @"dd";
            break;
            
        default:
            break;
    }

    
    
    //NSDate *currentTime = [zeroTime dateByAddingTimeInterval:(currentIndex * 3600)];
    
    
    return [df stringFromDate:_currentTime];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1); //there are two relevant color states, "Stroke" -- used in Stroke drawing functions and "Fill" - used in fill drawing functions
    
    
    //now we build a "path"
    CGContextSetLineWidth(ctx, 1.0f);
    
    switch (currentMode) {
        case kZNTimelineMarkerModeHour:
            {
                float pixelsForFiveMins = self.frame.size.width / 12;
                
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
                        showLine = (self.frame.size.width >= 120);
                        CGContextSetLineWidth(ctx, 2.0f);
                        
                    } else {
                        startPoint = self.frame.size.height * 0.7;
                        showLine = (self.frame.size.width >= 240);
                        CGContextSetLineWidth(ctx, 1.0f);
                        
                    }
                    
                    if (showLine) {
                        CGContextMoveToPoint(ctx, i * pixelsForFiveMins, startPoint);
                        CGContextAddLineToPoint(ctx, i * pixelsForFiveMins, self.frame.size.height);
                        CGContextStrokePath(ctx);
                        
                    }
                }
                break;
            }
        default:
            break;
    }

    
}


@end

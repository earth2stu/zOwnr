//
//  ZNTimelineBar.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineBarView.h"
#import "HourMarkerView.h"
#import "DayMarkerView.h"

@interface ZNTimelineBar() {

    NSMutableArray *hourMarkerViews;
    NSMutableArray *dayMarkerViews;
    
}

- (void)updateHourMarkers:(NSNumber*)pixelsPerHour fromTime:(NSDate*)startTime toTime:(NSDate*)endTime;
- (void)updateDayMarkers:(NSNumber*)pixelsPerHour fromTime:(NSDate*)startTime toTime:(NSDate*)endTime;

@end

@implementation ZNTimelineBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)updatePixelsPerHour:(NSNumber*)pixelsPerHour fromTime:(NSDate*)startTime toTime:(NSDate*)endTime {
    
    //NSLog(@"setting up time markers");
    
    if ([pixelsPerHour floatValue] >= 20.0f) {
        [self updateHourMarkers:pixelsPerHour fromTime:startTime toTime:endTime];
    } else {
        [self updateDayMarkers:pixelsPerHour fromTime:startTime toTime:endTime];
    }
    
    
    //NSLog(@"done time markers");
    
}

- (void)updateHourMarkers:(NSNumber*)pixelsPerHour fromTime:(NSDate*)startTime toTime:(NSDate*)endTime {
    [dayMarkerViews makeObjectsPerformSelector:@selector(hideMarker)];
    if (!hourMarkerViews) {
        // add the time markers
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyyMMdd HH:00";
        
        // round start time down to nearest hour
        NSDate *firstHour = [df dateFromString:[df stringFromDate:startTime]];
        
        // round end time down to nearest hour
        NSDate *lastHour = [df dateFromString:[df stringFromDate:endTime]];
        
        // then add an hour
        lastHour = [lastHour dateByAddingTimeInterval:3600];
        
        
        //        currentTimeView = [[CurrentTimeView alloc] initWithPixelsPerHour:pixelsPerHour startTime:firstHour];
        //        [self addSubview:currentTimeView];
        
        //NSTimeInterval secondsLong = [lastHour timeIntervalSinceDate:firstHour];
        
        //totalHours = secondsLong / 3600;
        
        
        // add current time marker
        
        /*
         NSDateFormatter *f = [[NSDateFormatter alloc] init];
         f.dateFormat = @"hh";
         NSString *earliestTime = [f stringFromDate:event.startTime];
         
         NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
         [nf setNumberStyle:NSNumberFormatterNoStyle];
         NSNumber * myNumber = [nf numberFromString:earliestTime];
         */
        
        NSTimeInterval totalPeriod = [endTime timeIntervalSinceDate:startTime];
        float totalHours = (totalPeriod / 3600) + 1;
        
        hourMarkerViews = [[NSMutableArray alloc] init];
        
        for (int i = 0; i <= totalHours; i++) {
            
            int timeOffset = i * 3600;
            
            HourMarkerView *hmv = [[HourMarkerView alloc] initWithTime:[firstHour dateByAddingTimeInterval:timeOffset] startTime:firstHour pixelsPerHour:pixelsPerHour];
            [self addSubview:hmv];
            [hourMarkerViews addObject:hmv];
            
            /*
             HourMarkerView *hmv = [[HourMarkerView alloc] initWithTime:[nf stringFromNumber:[NSNumber numberWithInt:(i + [myNumber intValue])]] frame:CGRectMake(i * [pixelsPerHour floatValue], 0, 30, self.frame.size.height)];
             [self addSubview:hmv];
             [timeMarkerViews addObject:hmv];
             */
        }
        
        [hourMarkerViews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    } else {
        // time markers exist, update their location
        
        //[timeMarkerViews makeObjectsPerformSelector:@selector(updatePixelsPerHour:) withObject:[NSNumber numberWithFloat:pixelsPerHour]];
        [hourMarkerViews makeObjectsPerformSelector:@selector(setCurrentFrame:) withObject:pixelsPerHour];
        
        /*
         int i = 0;
         for (HourMarkerView *hmv in timeMarkerViews) {
         [hmv setFrame:CGRectMake(i * [pixelsPerHour floatValue], 0, 30, self.frame.size.height)];
         i++;
         }
         
         */
    }
}

- (void)updateDayMarkers:(NSNumber*)pixelsPerHour fromTime:(NSDate*)startTime toTime:(NSDate*)endTime {
    [hourMarkerViews makeObjectsPerformSelector:@selector(hideMarker)];
    
    if (!dayMarkerViews) {
        // add the time markers
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyyMMdd 12:00";
        
        // round start time down to nearest hour
        NSDate *firstDay = [df dateFromString:[df stringFromDate:startTime]];
        
        // round end time down to nearest hour
        NSDate *lastDay = [df dateFromString:[df stringFromDate:endTime]];
        
        // then add an hour
        lastDay = [lastDay dateByAddingTimeInterval:(3600 * 24)];
        
        
        //        currentTimeView = [[CurrentTimeView alloc] initWithPixelsPerHour:pixelsPerHour startTime:firstHour];
        //        [self addSubview:currentTimeView];
        
        //NSTimeInterval secondsLong = [lastHour timeIntervalSinceDate:firstHour];
        
        //totalHours = secondsLong / 3600;
        
        
        // add current time marker
        
        /*
         NSDateFormatter *f = [[NSDateFormatter alloc] init];
         f.dateFormat = @"hh";
         NSString *earliestTime = [f stringFromDate:event.startTime];
         
         NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
         [nf setNumberStyle:NSNumberFormatterNoStyle];
         NSNumber * myNumber = [nf numberFromString:earliestTime];
         */
        
        NSTimeInterval totalPeriod = [endTime timeIntervalSinceDate:startTime];
        float totalDays = (totalPeriod / 3600 / 24) + 1;
        
        dayMarkerViews = [[NSMutableArray alloc] init];
        
        for (int i = 0; i <= totalDays; i++) {
            
            int timeOffset = i * 3600 * 24;
            
            DayMarkerView *dmv = [[DayMarkerView alloc] initWithTime:[firstDay dateByAddingTimeInterval:timeOffset] startTime:firstDay pixelsPerHour:pixelsPerHour];
            [self addSubview:dmv];
            [dayMarkerViews addObject:dmv];
            
            /*
             HourMarkerView *hmv = [[HourMarkerView alloc] initWithTime:[nf stringFromNumber:[NSNumber numberWithInt:(i + [myNumber intValue])]] frame:CGRectMake(i * [pixelsPerHour floatValue], 0, 30, self.frame.size.height)];
             [self addSubview:hmv];
             [timeMarkerViews addObject:hmv];
             */
        }
        [dayMarkerViews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    } else {
        // time markers exist, update their location
        
        //[timeMarkerViews makeObjectsPerformSelector:@selector(updatePixelsPerHour:) withObject:[NSNumber numberWithFloat:pixelsPerHour]];
        [dayMarkerViews makeObjectsPerformSelector:@selector(setCurrentFrame:) withObject:pixelsPerHour];
        
        /*
         int i = 0;
         for (HourMarkerView *hmv in timeMarkerViews) {
         [hmv setFrame:CGRectMake(i * [pixelsPerHour floatValue], 0, 30, self.frame.size.height)];
         i++;
         }
         
         */
    }
}



@end

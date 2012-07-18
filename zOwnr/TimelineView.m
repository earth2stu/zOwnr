//
//  TimelineView.m
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "TimelineView.h"
#import "HourMarkerView.h"

@implementation TimelineView

@synthesize delegate;

- (id)initWithEvent:(Event*)theEvent frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        
        event = theEvent;
        
        NSLog(@"setting up timeline");
        
        //NSDateFormatter *f = [[NSDateFormatter alloc] init];
        //f.dateFormat = @"yyyy-MM-dd HH:mm";
        //startTime = [f dateFromString:@"2011-09-17 10:00"];
        //endTime = [f dateFromString:@"2011-09-17 22:00"];
        
        NSTimeInterval totalPeriod = [event.endTime timeIntervalSinceDate:event.startTime];
        
        totalHours = (totalPeriod / 3600) + 1;
        pixelsPerHour = [NSNumber numberWithFloat:(self.frame.size.width / totalHours)];
        
        locationViews = [[NSMutableArray alloc] init];
        
        int i = 0;
        for (EventLocation *location in event.eventLocations) {
            EventLocationTimelineView *locationView = [[EventLocationTimelineView alloc] initWithLocation:location frame:CGRectMake(0, ((i * kTLlocationOffset) + kTLtopMargin), 1000, kTLlocationHeight) pixelsPerHour:pixelsPerHour startTime:event.startTime];
            locationView.delegate = self;
            locationView.index = i;
            [self addSubview:locationView];
            [locationViews addObject:locationView];
            i++;
        }
        
        [self setLocationFrames];
        
        
        pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self addGestureRecognizer:pinchRecognizer];
        
        [self updateTimeMarkers];
        
        NSLog(@"done setting up timeline");
        
    }
    return self;
}

- (void)updateTimeMarkers {
    
    //NSLog(@"setting up time markers");
    
    if (!timeMarkerViews) {
        // add the time markers
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyyMMdd HH:00";
        
        // round start time down to nearest hour
        NSDate *firstHour = [df dateFromString:[df stringFromDate:event.startTime]];
        
        // round end time down to nearest hour
        NSDate *lastHour = [df dateFromString:[df stringFromDate:event.endTime]];
        
        // then add an hour
        lastHour = [lastHour dateByAddingTimeInterval:3600];
        
        
        currentTimeView = [[CurrentTimeView alloc] initWithPixelsPerHour:pixelsPerHour startTime:firstHour];
        [self addSubview:currentTimeView];
        
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
        
        timeMarkerViews = [[NSMutableArray alloc] init];
        
        for (int i = 0; i <= totalHours; i++) {
            
            int timeOffset = i * 3600;
            
            HourMarkerView *hmv = [[HourMarkerView alloc] initWithTime:[firstHour dateByAddingTimeInterval:timeOffset] startTime:firstHour pixelsPerHour:pixelsPerHour];
            [self addSubview:hmv];
            [timeMarkerViews addObject:hmv];
            
            /*
            HourMarkerView *hmv = [[HourMarkerView alloc] initWithTime:[nf stringFromNumber:[NSNumber numberWithInt:(i + [myNumber intValue])]] frame:CGRectMake(i * [pixelsPerHour floatValue], 0, 30, self.frame.size.height)];
            [self addSubview:hmv];
            [timeMarkerViews addObject:hmv];
             */
        }
    } else {
        // time markers exist, update their location
        
        //[timeMarkerViews makeObjectsPerformSelector:@selector(updatePixelsPerHour:) withObject:[NSNumber numberWithFloat:pixelsPerHour]];
        [timeMarkerViews makeObjectsPerformSelector:@selector(setCurrentFrame:) withObject:pixelsPerHour];
        
        /*
        int i = 0;
        for (HourMarkerView *hmv in timeMarkerViews) {
            [hmv setFrame:CGRectMake(i * [pixelsPerHour floatValue], 0, 30, self.frame.size.height)];
            i++;
        }
        
        */
    }
    
    //NSLog(@"done time markers");
    
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialSize = self.frame.size.width;
    }
    //NSLog(@"pinched %f", sender.scale);
    
    float newSize = initialSize * sender.scale;
    if (newSize < 480) {
        newSize = 480;
    }
    
    if (newSize > 6000) {
        newSize = 6000;
    }
    
    //NSLog(@"setting size to %f", newSize);
    
    self.frame = CGRectMake(0, 0, newSize, self.frame.size.height);
    UIScrollView *sv = (UIScrollView*)self.superview;
    [sv setContentSize:CGSizeMake(newSize, self.frame.size.height)];
    
    //CGRect visibleRect = CGRectIntersection(self.frame, self.superview.bounds);
    
    pixelsPerHour = [NSNumber numberWithFloat:(self.frame.size.width / totalHours)];
    
    
    [self updateTimeMarkers];
    [locationViews makeObjectsPerformSelector:@selector(updatePixelsPerHour:) withObject:pixelsPerHour];
    [self setLocationFrames];
    //NSLog(@"the visible part goes from : %f", visibleRect.origin.x);
    
    return;
}

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        EventLocationTimelineView *location1 = [[EventLocationTimelineView alloc] initWithFrame:CGRectMake(0, 0, 1000, 50)];
        [self addSubview:location1];
        EventLocationTimelineView *location2 = [[EventLocationTimelineView alloc] initWithFrame:CGRectMake(0, 60, 1000, 50)];
        [self addSubview:location2];
    }
    return self;
}
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setLocationFrames {
    int i = 0;
    int selectedOffset = 0;
    int height = 0;
    int totalHeight = 0;
    for (EventLocationTimelineView *tv in locationViews) {
        
        if (tv.isSelected) {
            height = kTLlocationSelectedHeight;
        } else {
            height = kTLlocationHeight;
        }
        
        tv.frame = CGRectMake(0, totalHeight + kTLtopMargin, self.frame.size.width, height);
        
        totalHeight += height;
        
        //if (tv.isSelected) {
        //    selectedOffset = kTLlocationSelectedHeight;
        // }
        
        i++;
    }
    
    
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, totalHeight + kTLtopMargin);
    
    UIScrollView *scrollView = (UIScrollView*)self.superview;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, (i * kTLlocationHeight) + selectedOffset + height);
}

- (void)selectEventItem:(EventItem *)e fromFrame:(CGRect)fromFrame inLocationView:(EventLocationTimelineView *)locationView {
    
    BOOL alreadySelected = locationView.isSelected;
    
    [locationViews makeObjectsPerformSelector:@selector(deselect)];
    
    locationView.isSelected = !alreadySelected;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        [self setLocationFrames];
        
    } completion:^(BOOL finished) {
        [locationViews makeObjectsPerformSelector:@selector(reapplyRecognizers)];
    }];
    
    //[delegate selectEventItem:e fromFrame:fromFrame];
}

- (void)setTransform:(CGAffineTransform)newValue;
{
    NSLog(@"transform");
    CGAffineTransform constrainedTransform = CGAffineTransformIdentity;
    constrainedTransform.a = newValue.a;
    [super setTransform:constrainedTransform];
}

- (void)didScroll:(UIScrollView*)scrollView {
    [locationViews makeObjectsPerformSelector:@selector(didScroll:) withObject:scrollView];
}

@end

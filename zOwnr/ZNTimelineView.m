//
//  ZNTimelineView.m
//  zOwnr
//
//  Created by Stuart Watkins on 31/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineView.h"
#import "ZNMenuItem.h"
#import "ZNSettings.h"

@implementation ZNTimelineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // set default timespan
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyyMMdd HH:mm";
        df.timeZone = [NSTimeZone localTimeZone];
        NSDate *fromTime = [df dateFromString:@"20110910 00:00"];
        NSDate *toTime = [df dateFromString:@"20110920 00:00"];
        
        // setup scroll view
        timelineScrollView = [[ZNTimelineScrollView alloc] initWithFrame:frame withDelegate:self];
        [timelineScrollView setTimespanFrom:fromTime to:toTime];
        [self addSubview:timelineScrollView];
        
        // subscribe to selecting and loading of objects
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectObject:) name:kZNChangeSelectionKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadObject:) name:kZNLoadedSelectionKey object:nil];
        
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [timelineScrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark TimelineScrollViewDelegate

- (void)didScrollToTimespan:(NSDate *)fromTime toTime:(NSDate *)toTime {
    ZNSettings *s = [ZNSettings shared];
    NSLog(@"did scroll to timespan. timeline is updating zone with fromTime:%@ and toTime:%@", fromTime, toTime);
    //[s updateCurrentZone:s.currentZone.pointNW pointSE:s.currentZone.pointSE fromTime:fromTime toTime:toTime];
    [s updateCurrentZoneFromTime:fromTime toTime:toTime];
}

#pragma mark MainBaseView

- (void)setFinalFrame:(CGRect)frame {
    
}


#pragma mark MenuView

- (NSDictionary*)menuGroups {
    
    ZNMenuItem *i = [[ZNMenuItem alloc] init];
    i.title = @"test timeline menu item";
    
    NSArray *items = [NSArray arrayWithObject:i];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:items, @"Test Group", nil];
    
    NSMutableDictionary *allGroups = [NSMutableDictionary dictionaryWithDictionary:[super standardMenuGroups]];
    
    [allGroups addEntriesFromDictionary:d];
    
    return allGroups;
    
}

#pragma mark Notifications

- (void)didLoadObject:(NSNotification*)notification {
    id object = notification.object;
    
    if ([object conformsToProtocol:@protocol(ZNTimelineView)]) {
        
        [timelineScrollView setCurrentObject:object];
        
    }
}

- (void)didSelectObject:(NSNotification*)notification {
    
    id object = notification.object;
    
    if ([object conformsToProtocol:@protocol(ZNTimelineView)]) {
        
        NSLog(@"new selection is timeline compatible");
        
        [timelineScrollView setCurrentObject:object];
        
        id<ZNTimelineView> o = (id<ZNTimelineView>)object;
        
        [timelineScrollView setTimespanFrom:[o startTime] to:[o endTime]];
    }
    
}


@end

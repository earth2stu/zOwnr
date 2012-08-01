//
//  ZNTimelineScrollView.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineScrollView3.h"
#import "ZNMenuItem.h"

@interface ZNTimelineScrollView3() {
    
    id<TimelineScrollDelegate> _delegate;
    
}

- (void)changeSelection:(NSNotification*)notification;

@end

@implementation ZNTimelineScrollView3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fromTime:(NSDate*)fromTime toTime:(NSDate*)toTime withDelegate:(id<TimelineScrollDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        // Initialization code
        _delegate = delegate;
        timelineScrollView = [[UIScrollView alloc] initWithFrame:frame];
        timelineScrollView.delegate = self;
        timelineScrollView.clipsToBounds = YES;
        [self addSubview:timelineScrollView];
        
        t = [[ZNTimelineView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) fromTime:fromTime toTime:toTime delegate:self];
        [timelineScrollView addSubview:t];
        [self didScrollToTimespan];
        
        // set notifications listened for
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelection:) name:kZNChangeSelectionKey object:nil];
        
    }
    return self;
}

- (id)initWithDelegate:(id<TimelineScrollDelegate>)delegate {
    // not used
    NSDate *fromTime = [NSDate dateWithTimeIntervalSinceNow:-(4 * 3600 * 24)];
    NSDate *toTime = [NSDate dateWithTimeIntervalSinceNow:(4 * 3600 * 24)];
    
    return [self initWithFrame:CGRectMake(0, 200, 480, 50) fromTime:fromTime toTime:toTime withDelegate:delegate];
    
    
}

- (id)initWithFrame:(CGRect)frame andObject:(id<ZNTimelineViewOld>)timelineObj
{
    //return [self initWithFrame:frame fromTime:timelineObj toTime:<#(NSDate *)#> withDelegate:<#(id<TimelineScrollDelegate>)#>
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        timelineObject = timelineObj;
        
        timelineScrollView = [[UIScrollView alloc] initWithFrame:frame];
        timelineScrollView.delegate = self;
        [self addSubview:timelineScrollView];
        
        //t = [[ZNTimelineView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) fromTime:fromTime toTime:toTime delegate:self];
        [timelineScrollView addSubview:t];
        
    }
    return self;
}



#pragma mark TimelineDelegate

- (void)selectCell:(id<TimelineCell>)cell {
    
}

- (void)selectRow:(id<TimelineRow>)row {
    
}

- (void)didScrollToTimespan {
    
    float startSeconds = timelineScrollView.contentOffset.x / [t.pixelsPerHour floatValue] * 3600;
    
    float endSeconds = (timelineScrollView.contentOffset.x + timelineScrollView.frame.size.width) / [t.pixelsPerHour floatValue] * 3600;
    
    [_delegate didScrollToTimespan:[t.fromTime dateByAddingTimeInterval:startSeconds] toTime:[t.toTime dateByAddingTimeInterval:endSeconds]];
    
    
}

- (void)startUpdatingSize {
    // work out the centre of the timeline to keep it there
    
    timelineCentre = (timelineScrollView.contentOffset.x + (timelineScrollView.frame.size.width / 2.0f)) / t.frame.size.width;

    
}

- (void)didUpdateSize {

    // work out the center of the viewable part of the timeline
    float newOffset = (timelineCentre * t.frame.size.width) - (timelineScrollView.frame.size.width / 2.0f);
    
    if (newOffset < 0) {
        newOffset = 0;
    }
    
    if (newOffset > t.frame.size.width - timelineScrollView.frame.size.width) {
        newOffset = t.frame.size.width - timelineScrollView.frame.size.width;
    }
    
    timelineScrollView.contentOffset = CGPointMake(newOffset, 0);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"did zoom");
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[t didScroll:scrollView];
//}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{   
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //enshore that the end of scroll is fired because apple are twats...
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3]; 
    
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"end zooming");
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[t didScroll:timelineScrollView];
    [self didScrollToTimespan];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    [t didScroll:scrollView];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return t;
}

/*
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [t setFrame:frame];
}
*/

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

- (void)changeSelection:(NSNotification *)notification {
    id notifObject = notification.object;
    
    if ([notifObject conformsToProtocol:@protocol(ZNTimelineViewOld)]) {
        // this object can be shown on the timeline ..
        NSLog(@"got a timeline compatible object");
    }
    
}

@end

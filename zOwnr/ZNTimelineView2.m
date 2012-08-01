//
//  ZNTimelineView.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineView2.h"

@implementation ZNTimelineView

@synthesize pixelsPerHour, fromTime, toTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fromTime:(NSDate*)initialFromTime toTime:(NSDate*)initialToTime delegate:(id<TimelineDelegate>)parent
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor redColor];
        
        delegate = parent;
        
        fromTime = initialFromTime;
        toTime = initialToTime;
        
        NSTimeInterval totalPeriod = [toTime timeIntervalSinceDate:fromTime];
        totalHours = (totalPeriod / 3600) + 1;
        pixelsPerHour = [NSNumber numberWithFloat:(self.frame.size.width / totalHours)];
        
        
        bar = [[ZNTimelineBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        [self addSubview:bar];
        
        pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self addGestureRecognizer:pinchRecognizer];
        
        [bar updatePixelsPerHour:pixelsPerHour fromTime:fromTime toTime:toTime];
        
    }
    return self;
}


#pragma mark Pinch

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialSize = self.frame.size.width;
        [delegate startUpdatingSize];
    }
    //NSLog(@"pinched %f", sender.scale);
    
    float newSize = initialSize * sender.scale;
    
    /*
    if (newSize < 480) {
        newSize = 480;
    }
    
    if (newSize > 6000) {
        newSize = 6000;
    }
    */
    
    UIScrollView *sv = (UIScrollView*)self.superview;
    
    
    float tempPPH = newSize / totalHours;
    
    if (tempPPH < kTLMinMarkerWidth / 24.0) {
        // less than one day marker
        newSize = kTLMinMarkerWidth * totalHours;
    }
    
    if (tempPPH > sv.frame.size.width) {
        // more than one hour marker in the whole screen
        newSize = sv.frame.size.width;
    }
    
    //NSLog(@"setting size to %f", newSize);
    
    self.frame = CGRectMake(0, 0, newSize, self.frame.size.height);
    bar.frame = CGRectMake(0, 0, newSize, 50);
    
    
    
    [sv setContentSize:CGSizeMake(newSize, self.frame.size.height)];
    
    //CGRect visibleRect = CGRectIntersection(self.frame, self.superview.bounds);
    
    pixelsPerHour = [NSNumber numberWithFloat:(self.frame.size.width / totalHours)];
    
    [delegate didUpdateSize];
    
    /*
    if ([pixelsPerHour floatValue] > 300.0f) {
        pixelsPerHour = [NSNumber numberWithFloat:300.0f];
    }
    
    if ([pixelsPerHour floatValue] < 20.0f) {
        pixelsPerHour = [NSNumber numberWithFloat:20.0f];
    }
    */
    
    
    
//    [self updateTimeMarkers];
    [bar updatePixelsPerHour:pixelsPerHour fromTime:fromTime toTime:toTime];
    
    
//    [locationViews makeObjectsPerformSelector:@selector(updatePixelsPerHour:) withObject:pixelsPerHour];
//    [self setLocationFrames];
    //NSLog(@"the visible part goes from : %f", visibleRect.origin.x);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        // call did scroll to 
        //[delegate didScrollToTimespan];
    }
    
    return;
}

/*
- (void)didScroll:(UIScrollView*)scrollView {
    //[locationViews makeObjectsPerformSelector:@selector(didScroll:) withObject:scrollView];
    
    
    // work out the start time visible
    float startSeconds = scrollView.contentOffset.x / [pixelsPerHour floatValue] * 3600;
    
    float endSeconds = (scrollView.contentOffset.x + scrollView.frame.size.width) / [pixelsPerHour floatValue] * 3600;
    
    [delegate didScrollToTimespan:[fromTime dateByAddingTimeInterval:startSeconds] toTime:[toTime dateByAddingTimeInterval:endSeconds]];
    
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


@end

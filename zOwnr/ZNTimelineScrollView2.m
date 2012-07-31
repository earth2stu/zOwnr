//
//  ZNTimelineScrollView2.m
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

// min frame width is 240 or zooming between days, quarter days, half days, days wont work

#import "ZNTimelineScrollView2.h"
#import "ZNMenuItem.h"

@interface ZNTimelineScrollView2() {
    
}

- (int)maxMarkersForFrameSize;
- (void)recenterIfNecessary;
- (CGSize)superFrameSize;
- (void)setMarkersToCurrentWidth;
- (void)setTimeLabels;
- (void)didSelectTimePeriod;
- (void)setupMarkersForCurrentPeriod;
- (void)fixMarkerWidth;
- (void)lockToClosest;
- (void)setZeroTimeForMarkers;

@end

@implementation ZNTimelineScrollView2

@synthesize responseInsets;
@synthesize minTime = _minTime;
@synthesize maxTime = _maxTime;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;


- (id)initWithFrame:(CGRect)frame withDelegate:(id<ZNTimelineScrollDelegate>)del;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // delegates
        scrollDelegate = del;
        self.delegate = self;
        
        // ui
        self.clipsToBounds = YES;
        [self setDecelerationRate:UIScrollViewDecelerationRateFast];
        self.showsHorizontalScrollIndicator = NO;
        
        
        int m = [self maxMarkersForFrameSize];
        
        NSLog(@"max markers int=%i", m);
        
//        currentMarkerWidth = kZNMinTimeMarkerSize;
//        currentMarkerMode = kZNTimelineMarkerModeDay;
        
        
        //self.contentSize = CGSizeMake(([self maxMarkersForFrameSize] + 2) * kZNMinTimeMarkerSize, self.frame.size.height);
        
        
        // pinch zooming
        isZooming = NO;
        pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self addGestureRecognizer:pinchRecognizer];
        
        // labels
        rightStaticTime = [[UILabel alloc] initWithFrame:CGRectMake(minMarkerWidth + 5, 20, 180, 20)];
        [rightStaticTime setBackgroundColor:[UIColor clearColor]];
        rightStaticTime.font = [UIFont systemFontOfSize:10];
        rightStaticTime.alpha = 0.8f;
        [self addSubview:rightStaticTime];
        //[self insertSubview:rightStaticTime atIndex:-100];
        
        [self setMarkersToCurrentWidth];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectObject:) name:kZNChangeSelectionKey object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadObject:) name:kZNLoadedSelectionKey object:nil];
        
        //[self didSelectTimePeriod];
    }
    return self;
}

- (void)setTimespanFrom:(NSDate*)fromTime to:(NSDate*)toTime {
    self.startTime = fromTime;
    self.endTime = toTime;
    [self setupMarkersForCurrentPeriod];
    [self didSelectTimePeriod];
}

- (void)setupMarkersForCurrentPeriod {
    
    NSLog(@"setting up markers for current period");
    
    // let's always start with days as a minimum display
    
    // get the days either side of the to and from dates
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd 00:00";
    
    NSDate *fromDay = [df dateFromString:[df stringFromDate:self.startTime]];
    NSDate *toDay = [df dateFromString:[df stringFromDate:self.endTime]];
    toDay = [toDay dateByAddingTimeInterval:3600 * 24];
    
    
    NSTimeInterval totalDays = [toDay timeIntervalSinceDate:fromDay] / (3600 * 24);
    
    if (totalDays > maxMarkers) {
        // we have more days than we can show, just show the maximum
        currentMarkerMode = kZNTimelineMarkerModeDay;
        currentMarkerWidth = minMarkerWidth;
    } else {
        // work out the mode for this period
        if (totalDays <= maxMarkers / 2) {
            // we can fit it into half days
            currentMarkerMode = kZNTimelineMarkerModeHalfDay;
            currentMarkerWidth = self.frame.size.width / (totalDays * 2);
        } else {
            if (totalDays <= maxMarkers / 4) {
                currentMarkerMode = kZNTimelineMarkerModeQuarterDay;
                currentMarkerWidth = self.frame.size.width / (totalDays * 4);
            } else {
                currentMarkerMode = kZNTimelineMarkerModeDay;
                currentMarkerWidth = self.frame.size.width / totalDays;
            }
        }
    }
    
    [self fixMarkerWidth];
    
    currentZeroTime = fromDay;
    
    [self setZeroTimeForMarkers];
    
    [self setMarkersToCurrentWidth];
    
    [self lockToClosest];

}

- (void)fixMarkerWidth {
    
    NSLog(@"fixing marker width");
    
    // changes approximated marker width to one that will fit exactly in this frame
    
    int numShowing = lroundf(self.frame.size.width / currentMarkerWidth);
    numShowing = self.frame.size.width / currentMarkerWidth;
    
    currentMarkerWidth = self.frame.size.width / numShowing;
    
    // only deal with 2 more than we need
    self.contentSize = CGSizeMake((numShowing + 2) * currentMarkerWidth, self.frame.size.height);
    
    NSLog(@"setting content width to:%f", (numShowing + 2) * currentMarkerWidth);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (frame.size.height <= kMainEdgeViewHeight || frame.size.width <= kMainEdgeViewHeight) {
        return;
    }
    
    // need to reset everything cos our base size has changed
    
    // work out the minimum marker width
    maxMarkers = self.frame.size.width / kZNMinTimeMarkerSize;
    minMarkerWidth = self.frame.size.width / maxMarkers;

    if (timeMarkers) {
        [timeMarkers makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [timeMarkers removeAllObjects];
    } else {
        timeMarkers = [NSMutableArray array];
    }
    
    /*
    NSDate *zeroTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    
    NSDate *dayZeroTime = [df dateFromString:[df stringFromDate:zeroTime]];
    currentZeroTime = dayZeroTime;
    */
    
    for (int i = 0; i < maxMarkers + 2; i++) {
        ZNTimeMarkerView *timeMarker = [[ZNTimeMarkerView alloc] initWithIndex:i];
        //ZNTimeMarkerView *timeMarker = [[ZNTimeMarkerView alloc] initWithFrame:CGRectMake(i * kZNMinTimeMarkerSize, 0, kZNMinTimeMarkerSize, 50) andIndex:i zeroTime:dayZeroTime];
        [timeMarker setMarkerMode:currentMarkerMode];
        [timeMarkers addObject:timeMarker];
        [self addSubview:timeMarker];
    }
    
    
    if (self.startTime && self.endTime) {
        [self setupMarkersForCurrentPeriod];
    }
    
    [self bringSubviewToFront:rightStaticTime];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //if (!self.isDecelerating) {
    if (!isZooming) {
        [self recenterIfNecessary];

    }
    
    [self setTimeLabels];
            //}
    
}

- (CGSize)superFrameSize {
    return CGSizeMake(self.frame.size.width + responseInsets.right, self.frame.size.height);
}

- (int)timeDiffForMarkerMode {
    
}

- (void)recenterIfNecessary {
    // how far is the visible screen from the left edge of the markers
    CGPoint currentOffset = [self contentOffset];
    // how wide is the current set of markers
    CGFloat contentWidth = [self contentSize].width;
    //NSLog(@"contentWidth is now:%f", contentWidth);
    
    // what is the x offset point if we are in the middle?
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    // how far is the current content offset(ted) from the central point?
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    
    //NSLog(@"dist from center = %f", distanceFromCenter);
    
    if (distanceFromCenter > currentMarkerWidth) {
        
        // we have gone too far one way or the other
        // move the scroll container back to the middle
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
     
        //NSLog(@"setting offset to: %f", centerOffsetX);
        
        int diffToApply;
        
        NSDate *newZeroTime;
        
        int timeDiff = 0;
        
        switch (currentMarkerMode) {
            case kZNTimelineMarkerModeDay:
                timeDiff = (3600 * 24);
                break;
                
            case kZNTimelineMarkerModeHalfDay:
                timeDiff = (3600 * 12);
                break;
                
            case kZNTimelineMarkerModeQuarterDay:
                timeDiff = (3600 * 6);
                break;
                
            case kZNTimelineMarkerModeHour:
                timeDiff = 3600;
                break;
                
                            
            default:
                break;
        }
        
        if (currentOffset.x < centerOffsetX) {
            // we have scrolled right
            //NSLog(@"right");
            // shift all time markers to show one less than they are currently
            diffToApply = -1;
            
            newZeroTime = [currentZeroTime dateByAddingTimeInterval:timeDiff * -1];
            
        } else {
            //NSLog(@"left");
            // shift all time markers to show one more than they are currently
            diffToApply = 1;
            newZeroTime = [currentZeroTime dateByAddingTimeInterval:timeDiff];
        }
        
        currentZeroTime = newZeroTime;
        
        // move content by the same amount so it appears to stay still
        [self setZeroTimeForMarkers];
        
    }
     
}

- (void)setZeroTimeForMarkers {
    
    NSLog(@"setting zero time for markers");
    
    for (ZNTimeMarkerView *m in timeMarkers) {
        //[m setNewIndex:diffToApply];
        [m setNewZeroTime:currentZeroTime];
        //CGPoint center = [labelContainerView convertPoint:label.center toView:self];
        //            center.x += (centerOffsetX - currentOffset.x);
        //            label.center = [self convertPoint:center toView:labelContainerView];
    }
}

- (void)setTimeLabels {

    [rightStaticTime setFrame:CGRectMake(self.contentOffset.x + 5, rightStaticTime.frame.origin.y, rightStaticTime.frame.size.width, rightStaticTime.frame.size.height)];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    switch (currentMarkerMode) {
        case kZNTimelineMarkerModeDay:
            df.dateFormat = @"MMMM yyyy";
            break;
            
        case kZNTimelineMarkerModeHalfDay:
            df.dateFormat = @"MMMM yyyy";
            break;
            
        case kZNTimelineMarkerModeQuarterDay:
            df.dateFormat = @"MMMM yyyy";
            break;
            
        case kZNTimelineMarkerModeHour:
            df.dateFormat = @"dd MMMM yyyy";
            break;
            
        default:
            break;
    }
    
    [rightStaticTime setText:[df stringFromDate:currentZeroTime]];
    
}

#pragma mark Calculations

- (int)maxMarkersForFrameSize {
    // only make 2 more than the max number of timemarkers that can fit on the screen
    
    NSLog(@"width= %f, minsize= %f, numMarkers=%f", self.frame.size.width, kZNMinTimeMarkerSize, self.frame.size.width / kZNMinTimeMarkerSize);
    
    
    return (self.frame.size.width / kZNMinTimeMarkerSize);
}

- (kZNTimelineMarkerMode)modeForCurrent {
    
}


- (void)resetToSize {
    
    
    
}


- (void)lockToClosest {
    
    NSLog(@"locking to closest marker");
    
//    NSLog(@"content offset = %f with width %f", self.contentOffset.x, currentMarkerWidth);
    
//    if (self.contentOffset.x < (currentMarkerWidth / 2)) {
//        [self setContentOffset:CGPointMake(0, 0) animated:YES];
//    } else {
        [self setContentOffset:CGPointMake(currentMarkerWidth, 0) animated:YES];
//    }
    
    [self didSelectTimePeriod];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self lockToClosest];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self lockToClosest];
        //[self setContentOffset:CGPointMake(kZNMinTimeMarkerSize, 0) animated:YES];
    }
}




- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialPinchMarkerSize = currentMarkerWidth;
        initialPinchScaleFactor = 1.0f;
        isZooming = YES;
//        [delegate startUpdatingSize];
    }
    //NSLog(@"pinched %f", sender.scale);
    
    float newMarkerWidth = initialPinchMarkerSize * sender.scale * sender.scale * initialPinchScaleFactor;
    
    if (newMarkerWidth < minMarkerWidth) {
        switch (currentMarkerMode) {
            case kZNTimelineMarkerModeHour:
                // move to quarter day
                currentMarkerMode = kZNTimelineMarkerModeQuarterDay;
                newMarkerWidth = newMarkerWidth * 6.0f;
                initialPinchScaleFactor = initialPinchScaleFactor * 6.0f;
                NSLog(@"changing from hour to quarter day");
                break;
                
            case kZNTimelineMarkerModeQuarterDay:
                // lets move from quarter day to half day mode
                
                currentMarkerMode = kZNTimelineMarkerModeHalfDay;
                newMarkerWidth = newMarkerWidth * 2.0f;
                initialPinchScaleFactor = initialPinchScaleFactor * 2.0f;
                NSLog(@"changing from quarter to half");
                break;
                
            case kZNTimelineMarkerModeHalfDay:
                // lets move from half to quarter
                
                currentMarkerMode = kZNTimelineMarkerModeDay;
                newMarkerWidth = newMarkerWidth * 2.0f;
                initialPinchScaleFactor = initialPinchScaleFactor * 2.0f;
                NSLog(@"changing from half to day");
                break;
                
            case kZNTimelineMarkerModeDay:
                // stay in day mode
                
                newMarkerWidth = minMarkerWidth;
                break;
                
            default:
                break;
        }
        
    } else {
    
    //if (newMarkerWidth > self.frame.size.width / 2) {
        
        switch (currentMarkerMode) {
            
            case kZNTimelineMarkerModeDay:
                // lets move from day to half day mode
                
                if (newMarkerWidth > minMarkerWidth * 2.0f) {
                    currentMarkerMode = kZNTimelineMarkerModeHalfDay;
                    newMarkerWidth = newMarkerWidth / 2.0f;
                    initialPinchScaleFactor = initialPinchScaleFactor / 2.0f;
                    NSLog(@"changing from day to half day");
                }
                
                
                break;
                
            case kZNTimelineMarkerModeHalfDay:
                // lets move from day to half day mode
                
                if (newMarkerWidth > minMarkerWidth * 2.0f) {
                    
                    currentMarkerMode = kZNTimelineMarkerModeQuarterDay;
                    newMarkerWidth = newMarkerWidth / 2.0f;
                    initialPinchScaleFactor = initialPinchScaleFactor / 2.0f;
                    NSLog(@"changing from half to quarter day");
                }
                break;
                
            case kZNTimelineMarkerModeQuarterDay:
                // lets move from day to half day mode
                
                if (newMarkerWidth > minMarkerWidth * 6.0f) {
                    
                    currentMarkerMode = kZNTimelineMarkerModeHour;
                    newMarkerWidth = newMarkerWidth / 6.0f;
                    initialPinchScaleFactor = initialPinchScaleFactor / 6.0f;
                    NSLog(@"changing from quarter to hour");
                }
                break;
                
            case kZNTimelineMarkerModeHour:
                // this is the biggest we can get
                
                if (newMarkerWidth > self.frame.size.width / 2.0f) {
                    newMarkerWidth = self.frame.size.width / 2.0f;
                    //initialPinchScaleFactor = initialPinchScaleFactor / 2.0f;
                }
                
                
                break;
                
            default:
                break;
        }
        
        //newMarkerWidth = self.frame.size.width / 2;
    }
    
    currentMarkerWidth = newMarkerWidth;
    
    self.contentSize = CGSizeMake([timeMarkers count] * currentMarkerWidth, self.frame.size.height);

    
    [self setMarkersToCurrentWidth];
        
    /*
     if (newSize < 480) {
     newSize = 480;
     }
     
     if (newSize > 6000) {
     newSize = 6000;
     }
     */
    
     /*   
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
    
    */
    
    //[sv setContentSize:CGSizeMake(newSize, self.frame.size.height)];
    
    //CGRect visibleRect = CGRectIntersection(self.frame, self.superview.bounds);
    
//    pixelsPerHour = [NSNumber numberWithFloat:(self.frame.size.width / totalHours)];
    
//    [delegate didUpdateSize];
    
    /*
     if ([pixelsPerHour floatValue] > 300.0f) {
     pixelsPerHour = [NSNumber numberWithFloat:300.0f];
     }
     
     if ([pixelsPerHour floatValue] < 20.0f) {
     pixelsPerHour = [NSNumber numberWithFloat:20.0f];
     }
     */
    
    
    
    //    [self updateTimeMarkers];
//    [bar updatePixelsPerHour:pixelsPerHour fromTime:fromTime toTime:toTime];
    
    
    //    [locationViews makeObjectsPerformSelector:@selector(updatePixelsPerHour:) withObject:pixelsPerHour];
    //    [self setLocationFrames];
    //NSLog(@"the visible part goes from : %f", visibleRect.origin.x);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        // call did scroll to 
        //[delegate didScrollToTimespan];
        
        // we need to set everything to the closest multiple of the current width of the frame
        
        [self fixMarkerWidth];
        
        [self setMarkersToCurrentWidth];
        
        
        isZooming = NO;
        [self lockToClosest];
    }
    
    return;
}

- (void)didSelectTimePeriod {
    NSLog(@"selecting time period");
    
    ZNTimeMarkerView *startView = [timeMarkers objectAtIndex:1];
    
    int numShowing = lroundf(self.frame.size.width / currentMarkerWidth);
    numShowing = self.frame.size.width / currentMarkerWidth;
    
    ZNTimeMarkerView *endView = [timeMarkers objectAtIndex:numShowing + 1];
    
    
    self.startTime = startView.currentTime;
    self.endTime = endView.currentTime;
    
    [scrollDelegate didScrollToTimespan:startView.currentTime toTime:endView.currentTime];
}

- (void)setMarkersToCurrentWidth {
    NSLog(@"setting markers to currentWidth");
    int i = 0;
    for (ZNTimeMarkerView *m in timeMarkers) {
        [m setFrame:CGRectMake(i * currentMarkerWidth, 0, currentMarkerWidth, 50)];
        [m setMarkerMode:currentMarkerMode];
        i++;
    }
    [timeMarkers makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark MenuView

- (NSDictionary*)menuGroups {
    
    ZNMenuItem *i = [[ZNMenuItem alloc] init];
    i.title = @"test timeline menu item";
    
    NSArray *items = [NSArray arrayWithObject:i];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:items, @"Test Group", nil];
    
    //NSMutableDictionary *allGroups = [NSMutableDictionary dictionaryWithDictionary:[super standardMenuGroups]];
    // oops we aren't a subclass of the base class :(
    
    NSMutableDictionary *allGroups = [NSMutableDictionary dictionary];
    
    [allGroups addEntriesFromDictionary:d];
    
    return allGroups;
    
}

#pragma mark Notifications

- (void)didLoadObject:(NSNotification*)notification {
    id object = notification.object;
    
    if ([object conformsToProtocol:@protocol(ZNTimelineView)]) {
        
        id<ZNTimelineView> o = (id<ZNTimelineView>)object;
        
        [self setTimespanFrom:[o startTime] to:[o endTime]];
    }
}

- (void)didSelectObject:(NSNotification*)notification {
    
    id object = notification.object;
    
    if ([object conformsToProtocol:@protocol(ZNTimelineView)]) {
        
        id<ZNTimelineView> o = (id<ZNTimelineView>)object;
        
        [self setTimespanFrom:[o startTime] to:[o endTime]];
    }
    
}


@end

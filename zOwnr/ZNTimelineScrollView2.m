//
//  ZNTimelineScrollView2.m
//  zOwnr
//
//  Created by Stuart Watkins on 27/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

// min frame width is 240 or zooming between days, quarter days, half days, days wont work

#import "ZNTimelineScrollView2.h"

@interface ZNTimelineScrollView2() {
    
}

- (int)numMarkersForFrameSize;
- (void)recenterIfNecessary;
- (CGSize)superFrameSize;
- (void)setMarkersToCurrentWidth;

@end

@implementation ZNTimelineScrollView2

@synthesize responseInsets;
@synthesize minTime = _minTime;
@synthesize maxTime = _maxTime;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //responseInsets = respInsets;
        self.delegate = self;
        self.clipsToBounds = YES;
        [self setDecelerationRate:UIScrollViewDecelerationRateFast];
        isZooming = NO;
        
        currentMarkerWidth = kZNMinTimeMarkerSize;
        currentMarkerMode = kZNTimelineMarkerModeHour;
        
        //self.pagingEnabled = YES;
        //self.responseInsets = UIEdgeInsetsMake(0, 0, 0, superFrame.size.width - kZNMinTimeMarkerSize);
        
        //[self setFrame:CGRectMake(0, 0, kZNMinTimeMarkerSize, superFrame.size.height)];
        
        self.contentSize = CGSizeMake(([self numMarkersForFrameSize] + 2) * kZNMinTimeMarkerSize, self.frame.size.height);
        
        self.showsHorizontalScrollIndicator = NO;
        
        pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self addGestureRecognizer:pinchRecognizer];
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // need to reset everything cos our base size has changed
    
    timeMarkers = [NSMutableArray array];
    
    NSDate *zeroTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    
    NSDate *dayZeroTime = [df dateFromString:[df stringFromDate:zeroTime]];
    
    for (int i = 0; i < [self numMarkersForFrameSize] + 2; i++) {
        ZNTimeMarkerView *timeMarker = [[ZNTimeMarkerView alloc] initWithFrame:CGRectMake(i * kZNMinTimeMarkerSize, 0, kZNMinTimeMarkerSize, 50) andIndex:i zeroTime:dayZeroTime];
        [timeMarker setMarkerMode:currentMarkerMode];
        [timeMarkers addObject:timeMarker];
        [self addSubview:timeMarker];
    }
    
    self.contentOffset = CGPointMake(kZNMinTimeMarkerSize, 0);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //if (!self.isDecelerating) {
    if (!isZooming) {
        [self recenterIfNecessary];

    }
            //}
    
}

- (CGSize)superFrameSize {
    return CGSizeMake(self.frame.size.width + responseInsets.right, self.frame.size.height);
}

- (void)recenterIfNecessary {
    // how far is the visible screen from the left edge of the markers
    CGPoint currentOffset = [self contentOffset];
    // how wide is the current set of markers
    CGFloat contentWidth = [self contentSize].width;
    NSLog(@"contentWidth is now:%f", contentWidth);
    
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
        
        if (currentOffset.x < centerOffsetX) {
            // we have scrolled right
            //NSLog(@"right");
            // shift all time markers to show one less than they are currently
            diffToApply = -1;
        } else {
            //NSLog(@"left");
            // shift all time markers to show one more than they are currently
            diffToApply = 1;
        }
        
        
        // move content by the same amount so it appears to stay still
        for (ZNTimeMarkerView *m in timeMarkers) {
            [m setNewIndex:diffToApply];
            //CGPoint center = [labelContainerView convertPoint:label.center toView:self];
//            center.x += (centerOffsetX - currentOffset.x);
//            label.center = [self convertPoint:center toView:labelContainerView];
        }
        
    }
     
}

#pragma mark Calculations

- (int)numMarkersForFrameSize {
    // only make 2 more than the max number of timemarkers that can fit on the screen
    return (self.frame.size.width / kZNMinTimeMarkerSize);
}

- (kZNTimelineMarkerMode)modeForCurrent {
    
}


- (void)resetToSize {
    
    
    
}


- (void)lockToClosest {
    
//    NSLog(@"content offset = %f with width %f", self.contentOffset.x, currentMarkerWidth);
    
//    if (self.contentOffset.x < (currentMarkerWidth / 2)) {
//        [self setContentOffset:CGPointMake(0, 0) animated:YES];
//    } else {
        [self setContentOffset:CGPointMake(currentMarkerWidth, 0) animated:YES];
//    }
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
    
    float newMarkerWidth = initialPinchMarkerSize * sender.scale * initialPinchScaleFactor;
    
    if (newMarkerWidth < kZNMinTimeMarkerSize) {
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
                
                newMarkerWidth = kZNMinTimeMarkerSize;
                break;
                
            default:
                break;
        }
        
    } else {
    
    //if (newMarkerWidth > self.frame.size.width / 2) {
        
        switch (currentMarkerMode) {
            
            case kZNTimelineMarkerModeDay:
                // lets move from day to half day mode
                
                if (newMarkerWidth > kZNMinTimeMarkerSize * 2.0f) {
                    currentMarkerMode = kZNTimelineMarkerModeHalfDay;
                    newMarkerWidth = newMarkerWidth / 2.0f;
                    initialPinchScaleFactor = initialPinchScaleFactor / 2.0f;
                    NSLog(@"changing from day to half day");
                }
                
                
                break;
                
            case kZNTimelineMarkerModeHalfDay:
                // lets move from day to half day mode
                
                if (newMarkerWidth > kZNMinTimeMarkerSize * 2.0f) {
                    
                    currentMarkerMode = kZNTimelineMarkerModeQuarterDay;
                    newMarkerWidth = newMarkerWidth / 2.0f;
                    initialPinchScaleFactor = initialPinchScaleFactor / 2.0f;
                    NSLog(@"changing from half to quarter day");
                }
                break;
                
            case kZNTimelineMarkerModeQuarterDay:
                // lets move from day to half day mode
                
                if (newMarkerWidth > kZNMinTimeMarkerSize * 6.0f) {
                    
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
        
        int numShowing = lroundf(self.frame.size.width / currentMarkerWidth);
        
        
        currentMarkerWidth = self.frame.size.width / numShowing;
        
        // only deal with 2 more than we need
        self.contentSize = CGSizeMake((numShowing + 2) * currentMarkerWidth, self.frame.size.height);
        
        NSLog(@"setting content width to:%f", (numShowing + 2) * currentMarkerWidth);
        
        [self setMarkersToCurrentWidth];
        
        
        isZooming = NO;
        [self lockToClosest];
    }
    
    return;
}

- (void)setMarkersToCurrentWidth {
    int i = 0;
    for (ZNTimeMarkerView *m in timeMarkers) {
        [m setFrame:CGRectMake(i * currentMarkerWidth, 0, currentMarkerWidth, 50)];
        [m setMarkerMode:currentMarkerMode];
        i++;
    }
    
    
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

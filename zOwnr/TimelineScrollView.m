//
//  TimelineScrollView.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "TimelineScrollView.h"

@protocol TimelineScrollViewDelegate <NSObject>

- (void)didScrollToTimespan:(NSDate*)fromTime toTime:(NSDate*)toTime;

@end

@interface TimelineScrollView() {
    
    UIScrollView *scrollView;
    TimelineView *t;
    NSDate *fromTime;
    NSDate *toTime;
}

@end

@implementation TimelineScrollView

- (id)initWithFrame:(CGRect)frame fromTime:(NSDate*)fromTime toTime:(NSDate*)toTime {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"did zoom");
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [t didScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    [t didScroll:scrollView];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return t;
}


@end

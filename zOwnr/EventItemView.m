//
//  EventItemView.m
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventItemView.h"

@implementation EventItemView



- (id)initWithEventItem:(EventItem*)theEventItem fromVisibleFrame:(CGRect)visibleFrame {
    self = [super init];
    if (self) {
        // Initialization code
        NSLog(@"initializing eventitemview");
        item = theEventItem;
        presentersVisibleFrame = visibleFrame;
        self.frame = presentersVisibleFrame;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(20, 20, 200, 50);
        }];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end

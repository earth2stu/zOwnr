//
//  EventItemView.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventItem.h"

@interface EventItemView : UIView {
    EventItem *item;
    CGRect presentersVisibleFrame;
    
}


- (id)initWithEventItem:(EventItem*)theEventItem fromVisibleFrame:(CGRect)visibleFrame;

@end

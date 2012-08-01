//
//  ZNTimelineView.h
//  zOwnr
//
//  Created by Stuart Watkins on 31/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNMainBaseView.h"
#import "ZNMenuView.h"
#import "ZNTimelineScrollView.h"

/// This allows objects to be set as the root object of the Timeline. They must provide the following data:

@protocol ZNTimelineView <NSObject>

- (NSArray*)rows; // each object must conform to ZNTimelineRowView
- (NSDate*)startTime;
- (NSDate*)endTime;

@end

@interface ZNTimelineView : ZNMainBaseView <ZNMenuView,
                                            ZNTimelineScrollDelegate> // has a menu
{
    ZNTimelineScrollView *timelineScrollView;
}

@end

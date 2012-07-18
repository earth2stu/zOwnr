//
//  TimelineViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineView.h"
#import "Event.h"
#import "ZownrService.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>


@interface TimelineViewController : UIViewController <UIScrollViewDelegate, RKObjectLoaderDelegate, TimelineDelegate> {
    IBOutlet UIScrollView *timelineScroll;
    TimelineView *t;
    Event *event;
}

@property (nonatomic, strong) Event *event;
- (void)initEvent;


@end

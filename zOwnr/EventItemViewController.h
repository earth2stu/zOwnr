//
//  EventItemViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 10/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventItem.h"

@interface EventItemViewController : UIViewController {
    EventItem *eventItem;
    IBOutlet UILabel *titleLabel;
    CGRect fromFrame;
    IBOutlet UIView *mainView;
}

@property (nonatomic, retain) EventItem *eventItem;
@property (assign) CGRect fromFrame;

@end

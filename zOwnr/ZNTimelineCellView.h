//
//  ZNTimelineCellView.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZNTimelineCellView <NSObject>

- (UIView*)viewForCell;
- (NSDate*)startTime;
- (NSDate*)endTime;
- (NSString*)title;

@end

@interface ZNTimelineCellView : UIView

@end

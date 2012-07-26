//
//  ZNTimelineRow.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZNTimelineRowView <NSObject>

- (NSString*)title;
- (NSDate*)startTime;
- (NSDate*)endTime;

@end

@interface ZNTimelineRowView : UIView

@end

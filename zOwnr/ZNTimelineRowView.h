//
//  ZNTimelineRow.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNTimelineCellView.h"

@class ZNTimelineRowView;

@protocol ZNTimelineRowViewDelegate <NSObject>

- (CGRect)frameForRow:(ZNTimelineRowView*)row;
- (CGRect)frameForCell:(ZNTimelineCellView*)cell;

@end

@protocol ZNTimelineRowView <NSObject>

- (NSString*)title;
- (NSDate*)startTime;
- (NSDate*)endTime;
- (NSArray*)cells;

@end

@interface ZNTimelineRowView : UIView <ZNTimelineCellViewDelegate>{
    id<ZNTimelineRowView> row;
}

@property (assign) int index;
@property (nonatomic, strong) id<ZNTimelineRowView> row;

- (id)initWithRow:(id<ZNTimelineRowView>)rowObject delegate:(id<ZNTimelineRowViewDelegate>)delegate;
- (void)updateLayout;

@end

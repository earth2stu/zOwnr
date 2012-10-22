//
//  ZNTimelineCellView.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNTimelineCellView;

@protocol ZNTimelineCellViewDelegate <NSObject>

- (CGRect)frameForCell:(ZNTimelineCellView*)cell;

@end

@protocol ZNTimelineCellView <NSObject>

- (UIView*)viewForCell;
- (NSDate*)startTime;
- (NSDate*)endTime;
- (NSString*)title;

@end


@interface ZNTimelineCellView : UIView {
    id<ZNTimelineCellView> cell;
}

@property (nonatomic, weak) id<ZNTimelineCellView> cell;

- (id)initWithCell:(id<ZNTimelineCellView>)cellObject delegate:(id<ZNTimelineCellViewDelegate>)delegate;
- (void)updateLayout;

@end

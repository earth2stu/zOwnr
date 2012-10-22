//
//  ZNTimelineContentView.h
//  zOwnr
//
//  Created by Stuart Watkins on 31/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNTimelineRowView.h"

@protocol ZNTimelineView;

@protocol ZNTimelineContentDelegate <NSObject>

- (float)xOffsetForTime:(NSDate*)time;

@end

@interface ZNTimelineContentView : UIView <ZNTimelineRowViewDelegate> {
    NSMutableArray *timelineRows;
}

@property (nonatomic, strong) NSMutableArray *timelineRows;
@property (nonatomic, weak) id<ZNTimelineView> currentObject;

- (id)initWithFrame:(CGRect)frame delegate:(id<ZNTimelineContentDelegate>)delegate;
- (void)updateLayout;
//- (void)setCurrentObject:(id<ZNTimelineView>)object;

@end

//
//  ZNTimelineRow.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineRowView.h"
#import "ZNTimelineCellView.h"

@interface ZNTimelineRowView() {
    id<ZNTimelineRowViewDelegate> _delegate;
}

@end

@implementation ZNTimelineRowView

@synthesize index;
@synthesize row = _row;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithRow:(id<ZNTimelineRowView>)rowObject delegate:(id<ZNTimelineRowViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _row = rowObject;
        
        //for (UIView *subView in self.subviews) {
        //    [subView removeFromSuperview];
        //}
        for (id<ZNTimelineCellView> cell in _row.cells) {
            ZNTimelineCellView *cellView = [[ZNTimelineCellView alloc] initWithCell:cell delegate:self];
            [self addSubview:cellView];
        }
        
    }
    return self;
}

- (void)updateLayout {

    [self.subviews makeObjectsPerformSelector:@selector(updateLayout)];
}


#pragma mark CellViewDelegate



- (CGRect)frameForCell:(ZNTimelineCellView*)cell {
    return [_delegate frameForCell:cell];
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

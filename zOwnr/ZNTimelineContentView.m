//
//  ZNTimelineContentView.m
//  zOwnr
//
//  Created by Stuart Watkins on 31/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineContentView.h"
#import "ZNTimelineView.h"
#import "ZNTimelineCellView.h"

@interface ZNTimelineContentView() {
    id<ZNTimelineContentDelegate> _delegate;
}
@end

@implementation ZNTimelineContentView

@synthesize currentObject = _currentObject;

- (id)initWithFrame:(CGRect)frame delegate:(id<ZNTimelineContentDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _delegate = delegate;
        self.backgroundColor = [UIColor orangeColor];
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        testLabel.text = @"blah";
        [self addSubview:testLabel];
        
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    int i = 0;
    for (id<ZNTimelineRowView> row in _currentObject.rows) {
        ZNTimelineRowView *rowView = [[ZNTimelineRowView alloc] initWithRow:row delegate:self];
        rowView.index = i;
        [self addSubview:rowView];
        
        i++;
    }
}

- (void)updateLayout {

    [self.subviews makeObjectsPerformSelector:@selector(updateLayout)];
}

- (void)setCurrentObject:(id<ZNTimelineView>)currentObject {
    _currentObject = currentObject;
    [self setupSubViews];
    [self updateLayout];
}

#pragma mark RowViewDelegate

- (CGRect)frameForCell:(ZNTimelineCellView*)cellView {
    
    ZNTimelineRowView *parentRow = (ZNTimelineRowView*)cellView.superview;
    
    float x = [_delegate xOffsetForTime:cellView.cell.startTime];
    float width = [_delegate xOffsetForTime:cellView.cell.endTime] - x;
    
    if ([cellView.cell.title isEqualToString:@"Josh Lang"]) {
        NSLog(@"x val is:%f", x);
    }
    
    return CGRectMake(x, parentRow.index * kZNRowHeight, width, kZNRowHeight);
}

- (CGRect)frameForRow:(ZNTimelineRowView*)row {
    //return CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
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

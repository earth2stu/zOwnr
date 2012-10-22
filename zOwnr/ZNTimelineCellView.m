//
//  ZNTimelineCellView.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTimelineCellView.h"

@interface ZNTimelineCellView() {
    id<ZNTimelineCellViewDelegate> _delegate;
}
@end

@implementation ZNTimelineCellView

@synthesize cell = _cell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCell:(id<ZNTimelineCellView>)cellObject delegate:(id<ZNTimelineCellViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _cell = cellObject;
        _delegate = delegate;
        
        self.backgroundColor = [UIColor greenColor];
        self.clipsToBounds = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        titleLabel.text = _cell.title;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)updateLayout {
    self.frame = [_delegate frameForCell:self];
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

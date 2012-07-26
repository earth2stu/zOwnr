//
//  ZNMenuItem.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMenuItem.h"

@implementation ZNMenuItem

@synthesize title;
@synthesize selector;
@synthesize target;
@synthesize selectedItem;

- (id)initWithTitle:(NSString*)itemTitle andTarget:(kMenuTarget)itemTarget andSelector:(SEL)itemSelector andSelected:(id)itemSelected {
    self = [super init];
    if (self) {
        title = itemTitle;
        target = itemTarget;
        selector = itemSelector;
        selectedItem = itemSelected;
    }
    return self;
}

@end

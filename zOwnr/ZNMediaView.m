//
//  ZNMediaView.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMediaView.h"
#import "ZNMenuItem.h"
#import "ZNSettings.h"

@implementation ZNMediaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)setFinalFrame:(CGRect)frame {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark MenuView

- (NSDictionary*)menuGroups {
    
    if ([[ZNSettings shared] isLoggedIn]) {
        //
    }
    
    ZNMenuItem *i = [[ZNMenuItem alloc] init];
    i.title = @"test media menu item";
    
    NSArray *items = [NSArray arrayWithObject:i];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:items, @"Test Group", nil];
    
    NSMutableDictionary *allGroups = [NSMutableDictionary dictionaryWithDictionary:[super standardMenuGroups]];
    [allGroups addEntriesFromDictionary:d];
    
    return allGroups;
    
}

@end

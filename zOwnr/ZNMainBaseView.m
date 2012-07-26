//
//  ZNMainBaseView.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMainBaseView.h"
#import "ZNMenuItem.h"
#import "ZNSettings.h"

@implementation ZNMainBaseView

- (NSDictionary*)standardMenuGroups {
    //ZNMenuItem *i = [[ZNMenuItem alloc] init];
    //i.title = @"Create Event";
    
    //NSArray *items = [NSArray arrayWithObject:i];
    
    NSMutableArray *items = [NSMutableArray array];
    
    if ([[ZNSettings shared] isCurrentUser]) {
        [items addObject:[[ZNMenuItem alloc] initWithTitle:@"Log out" andTarget:kMenuTargetSocial andSelector:@selector(doLogout) andSelected:nil] ];
    } else {
        [items addObject:[[ZNMenuItem alloc] initWithTitle:@"Log in" andTarget:kMenuTargetSocial andSelector:@selector(showLogin) andSelected:nil] ];
    }
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:items, @"zOwnr", nil];
    
    return d;
}


@end

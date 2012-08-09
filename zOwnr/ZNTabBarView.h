//
//  ZNTabBar.h
//  zOwnr
//
//  Created by Stuart Watkins on 26/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNMainBaseView.h"
#import "ZNTabContentView.h"

@interface ZNTabBarView : ZNMainBaseView {
    NSMutableDictionary *tabViews;
    ZNTabContentView *currentView;
    NSMutableDictionary *tabClasses;
}

//- (NSDictionary*)defaultTabClasses;
- (NSMutableDictionary*)defaultTabContentViews;

@end

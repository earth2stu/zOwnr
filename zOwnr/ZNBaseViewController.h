//
//  ZNBaseViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNMainView.h"
#import "ZNMenuView.h"
#import "ZNLogoView.h"
#import "ZNTitleView.h"
#import "ZNSettings.h"
#import "User.h"

@interface ZNBaseViewController : UIViewController <ZNLogoViewDelegate, ZNMainViewDelegate, ZNSettingsDelegate, ZNMenuViewDelegate> {
    ZNMainView *mainView;
    ZNMenuView *menuView;
    ZNLogoView *logoView;
    ZNTitleView *titleView;
    
    kQuadrantCorner currentQuadrant;
    kScreenMode currentScreenMode;
    
    BOOL isMenuOpen;
    
    id<ZNMenuView> currentMainView;
    
    User *currentUser;
}

- (void)setCurrentQuadrant:(kQuadrantCorner)quadrant;


@end


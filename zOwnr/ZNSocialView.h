//
//  ZNSocialView.h
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNMenuView.h"
#import "ZNMainBaseView.h"
#import "ZNSocialLoginView.h"
#import "FBConnect.h"
#import <RestKit/RestKit.h>
#import "ZNTabBarView.h"



@interface ZNSocialView : ZNTabBarView <ZNMenuView, ZNSocialLoginDelegate, FBSessionDelegate, RKObjectLoaderDelegate> {
    Facebook *facebook;
    ZNSocialLoginView *loginView;
    
}

- (void)showLogin;
- (void)doLogout;

@end

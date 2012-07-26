//
//  ZNAppDelegate.h
//  zOwnr
//
//  Created by Stuart Watkins on 11/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface ZNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) Facebook *facebook;

@end

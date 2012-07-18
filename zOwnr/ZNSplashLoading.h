//
//  SplashLoading.h
//  zownr
//
//  Created by Stuart Watkins on 8/09/11.
//  Copyright 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"

@interface ZNSplashLoading : UIViewController <RKObjectLoaderDelegate, UITabBarControllerDelegate>



@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) IBOutlet UIView *connectingView;

-(IBAction)didCancelLogin:(id)sender;
-(void) showTabBar;

@end


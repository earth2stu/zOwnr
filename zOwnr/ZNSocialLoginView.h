//
//  ZNSocialLoginView.h
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZNSocialLoginDelegate <NSObject>

- (void)facebookLogin;

@end

@interface ZNSocialLoginView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *loginTableView;
    id<ZNSocialLoginDelegate> delegate;
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id<ZNSocialLoginDelegate>)del;

@end

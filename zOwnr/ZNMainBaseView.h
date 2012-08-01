//
//  ZNMainBaseView.h
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNMainBaseView;

@protocol ZNMainBaseViewDelegate <NSObject>

- (void)setCurrentMainView:(ZNMainBaseView*)mainBaseView;

@end

@interface ZNMainBaseView : UIView

- (NSDictionary*)standardMenuGroups;
- (void)setFinalFrame:(CGRect)frame;

@end

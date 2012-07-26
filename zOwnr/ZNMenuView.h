//
//  ZNMenuView.h
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNBaseViewController;
@class ZNSocialView;
@class ZNMapView;
@class ZNMediaView;
@class ZNTimelineScrollView;



@protocol ZNMenuView <NSObject>

//

- (NSDictionary*)menuGroups;


@end

@protocol ZNMenuViewDelegate <NSObject>

- (ZNBaseViewController*)baseViewController;
- (ZNSocialView*)socialView;
- (ZNMediaView*)mediaView;
- (ZNTimelineScrollView*)timelineView;
- (ZNMapView*)mapView;
- (void)switchToMainView:(id<ZNMenuView>)switchMainView;

@end


@interface ZNMenuView : UIView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    UITableView *menuTableView;
    id<ZNMenuView>currentMenuView;
    id<ZNMenuViewDelegate> delegate;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id<ZNMenuViewDelegate>)del;
- (void)openMenu:(id<ZNMenuView>)menuView fromPoint:(CGPoint)point;
- (void)closeMenu;

@end

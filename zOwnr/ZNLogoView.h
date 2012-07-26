//
//  ZNQuadrantView.h
//  zOwnr
//
//  Created by Stuart Watkins on 18/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ZNLogoViewDelegate <NSObject>

- (void)didMoveToPoint:(float)point onEdge:(kQuadrantEdge)edge;
- (void)didSwitchToCorner:(kQuadrantCorner)corner;
- (void)didToggleMenuForCorner:(kQuadrantCorner)corner;
- (void)didCloseMenu;

- (void)openMenuForCorner:(kQuadrantCorner)corner;

@end

@interface ZNLogoView : UIView {
    kQuadrantEdge currentEdge;
    kQuadrantCorner currentCorner;
    CGPoint startPoint;

}

@property (nonatomic, retain) id<ZNLogoViewDelegate> delegate;

- (void)setCurrentCorner:(kQuadrantCorner)corner;

@end

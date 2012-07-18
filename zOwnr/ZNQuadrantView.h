//
//  ZNQuadrantView.h
//  zOwnr
//
//  Created by Stuart Watkins on 18/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    kQuadrantEdgeTop,
    kQuadrantEdgeBottom,
    kQuadrantEdgeLeft,
    kQuadrantEdgeRight
} kQuadrantEdge;

typedef enum {
    kQuadrantCornerTopLeft,
    kQuadrantCornerTopRight,
    kQuadrantCornerBottomLeft,
    kQuadrantCornerBottomRight
} kQuadrantCorner;

@protocol QuadrantDelegate <NSObject>

- (void)didMoveToPoint:(float)point onEdge:(kQuadrantEdge)edge;
- (void)didSwitchToCorner:(kQuadrantCorner)corner;

@end

@interface ZNQuadrantView : UIView {
    kQuadrantEdge currentEdge;
    kQuadrantCorner currentCorner;
    CGPoint startPoint;
}

@property (nonatomic, retain) id<QuadrantDelegate> delegate;

@end

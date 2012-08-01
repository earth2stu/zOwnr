//
//  ZNMainView.h
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

// 4 main views
#import "ZNTimelineView.h"
#import "ZNMapView.h"
#import "ZNSocialView.h"
#import "ZNMediaView.h"

#import "ZNMainBaseView.h"

#import "Zone.h"

@protocol ZNMainViewDelegate <NSObject>

//

- (void)setCurrentMainView:(id<ZNMenuView>)mainSubView;
- (void)openMenuFor:(id<ZNMenuView>)sender;

@end

@interface ZNMainView : UIView <ZNTimelineScrollDelegate, MapViewDelegate> {
    
    kQuadrantCorner currentQuadrant;
    
    ZNMapView *mapView;
    ZNTimelineView *timelineView;
    ZNSocialView *socialView;
    ZNMediaView *mediaView;
    
    Zone *currentZone;
    
    id<ZNMainViewDelegate> delegate;
}

@property (nonatomic, retain) ZNSocialView *socialView;
@property (nonatomic, retain) ZNMediaView *mediaView;
@property (nonatomic, retain) ZNMapView *mapView;
@property (nonatomic, retain) ZNTimelineView *timelineView;

- (id)initWithFrame:(CGRect)frame withDelegate:(id<ZNMainViewDelegate>)del;
- (void)setCurrentQuadrant:(kQuadrantCorner)quadrant;

@end

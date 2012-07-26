//
//  EventGroup.h
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNTimelineView.h"
#import "ZNMapView.h"

@interface EventGroup : NSObject <ZNMapView, ZNTimelineView>

@property (nonatomic, retain) NSArray *events;

@end

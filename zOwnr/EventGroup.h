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
#import "Zone.h"

@interface EventGroup : Zone <  ZNMapView, // can be the root object for a mapview
                                ZNTimelineView, // can be the root object for a timelineview
                                ZNSelectable, // this is really just so it can be set as the root of the main view
                                ZNLoadable> // this can be loaded

@property (nonatomic, retain) NSArray *events;

@end

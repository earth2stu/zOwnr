//
//  Event+Timeline.h
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNTimelineView.h"
#import "ZNTimelineRowView.h"
#import "Event.h"
#import <MapKit/MapKit.h>
#import "ZNMapAnnotationView.h"
#import "ZNMenuView.h"
#import "ZNObjectLoader.h"
#import "ZNMapView.h"

@interface Event (Timeline) <   ZNMenuView, // shows a menu when selected
                                ZNTimelineView, // can be root object for a timeline
                                ZNTimelineRowView, // can be root object for a timeline row
                                MKAnnotation, // can be shown on a map 
                                ZNMapPinView, // view to show on map
                                ZNSelectable, // can be selected
                                ZNLoadable,  // can be loaded
                                ZNMapView> // can be the root object for a mapview
                                    

@end

//
//  ZNMapView.h
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "ZNObjectLoader.h"
#import "Zone.h"
#import "ZNMenuView.h"
#import "ZNMainBaseView.h"

@protocol ZNMapView <NSObject>

- (NSArray*)annotations;

@end

@protocol MapViewDelegate <NSObject>

- (void)didScrollToRegion:(CLLocationCoordinate2D)pointNW pointSE:(CLLocationCoordinate2D)pointSE;
- (void)didSelectAnnotation:(id<MKAnnotation>)annotation;
- (Zone*)getCurrentZone;
- (void)openMenuFor:(id<ZNMenuView>)sender;

@end

//@interface ZNMapView : UIView <MKMapViewDelegate, NSFetchedResultsControllerDelegate> {
@interface ZNMapView : ZNMainBaseView <MKMapViewDelegate, ZNObjectLoaderDelegate, ZNMenuView> {
    MKMapView *mapView;
    BOOL isLocatingUser;
    ZNObjectLoader *objectLoader;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)zoomToUserLocation;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<MapViewDelegate>)delegate;

@end

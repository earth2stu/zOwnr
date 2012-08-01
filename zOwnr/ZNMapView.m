//
//  ZNMapView.m
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMapView.h"
#import <RestKit/RestKit.h>
#import "ZNMapAnnotationView.h"
#import "ZNMapOverlayView.h"

// just for the fetched results test
#import "ZNTimelineView.h"
#import "ZNMenuItem.h"
#import "Event.h"

// settings
#import "ZNSettings.h"
#import "Zone.h"

@interface ZNMapView() {
    id<MapViewDelegate> _delegate;
}

- (void)updateData;
- (void)showAnnotationsForObject:(id<ZNMapView>)object;

@end

@implementation ZNMapView

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithFrame:(CGRect)frame withDelegate:(id<MapViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
        _delegate = delegate;
        mapView = [[MKMapView alloc] initWithFrame:frame];
        mapView.delegate = self;
        [self addSubview:mapView];
        //isLocatingUser = YES;
        [self zoomToUserLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectObject:) name:kZNChangeSelectionKey object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadObject:) name:kZNLoadedSelectionKey object:nil];
        
        
        //self.fetchedResultsController.delegate = self;
        
    }
    return self;
}



- (void)showAnnotationsForObject:(id<ZNMapView>)object {
    
    // remove all except the ones we are re-adding
    NSMutableArray *annotationsToRemove = [NSMutableArray arrayWithArray:[mapView annotations]];
    [annotationsToRemove removeObjectsInArray:[object annotations]];
    [mapView removeAnnotations:annotationsToRemove];
    
    // re-add all of them
    NSArray *annotations = [object annotations];
    for (id<MKAnnotation> ann in annotations) {
        [mapView addAnnotation:ann];
    }
}



- (void)zoomToUserLocation {
    isLocatingUser = YES;
    mapView.showsUserLocation = YES;
    [mapView.userLocation addObserver:self 
                                forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{       
    
    if (!isLocatingUser) {
        [mapView.userLocation removeObserver:self forKeyPath:@"location"];
        return;
    }
    
    if ([keyPath isEqualToString:@"location"]) {
        
        /*
        if (!zownrPopup)
        {
            zownrPopup = [[ZNPointerPopupView alloc] initWithFrame:CGRectMake(50.0f, 100.0f, 150.0f, 70.0f)];
            zownrPopup.backgroundColor = [UIColor clearColor];
            [zownrPopup setText:@"Locating..."];
            [self.view addSubview:zownrPopup];
            
            NSString *pathString = [NSString stringWithFormat:@"/public/currentevent?latitude=%4.8f&longitude=%4.8f", self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude];
            
            
            
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pathString delegate:self];
            
            
        }
        */
        
        //if (mapView.userLocation.location.horizontalAccuracy <= 50.0f) {
            isLocatingUser = NO;
            [mapView.userLocation removeObserver:self forKeyPath:@"location"];
            
        //}
        
        //if (!isRegionZoomed) {
        MKCoordinateRegion region;
        region.center = mapView.userLocation.coordinate;  
        
        MKCoordinateSpan span; 
        span.latitudeDelta  = 0.01; // Change these values to change the zoom
        span.longitudeDelta = 0.01; 
        region.span = span;
        
        [mapView setRegion:region animated:YES];
        //    isRegionZoomed = YES;
        //}
        
        //[self updateLocationToServer:self.mapview.userLocation.coordinate updateType:@"map"];
        //        z.coordinate = self.mapview.userLocation.coordinate;
        
        
        //       if (!self.mapview.userLocation.isUpdating) {
        //    [self.mapview.userLocation removeObserver:self forKeyPath:@"location"];
        
        //        PersonAnnotation *bridgeAnnotation = [[PersonAnnotation alloc] initWithCoordinate:self.mapview.userLocation.coordinate];
        
        //            [self.mapview addAnnotation:bridgeAnnotation];
        
        //       }
        
    }
    
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [mapView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}


#pragma mark MapViewDelegate

- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated {
    
    MKMapRect mRect = mapView.visibleMapRect;
    MKMapPoint nwMapPoint = MKMapPointMake(mRect.origin.x, mRect.origin.y);
    MKMapPoint seMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMaxY(mRect));
    CLLocationCoordinate2D nwCoord = MKCoordinateForMapPoint(nwMapPoint);
    CLLocationCoordinate2D seCoord = MKCoordinateForMapPoint(seMapPoint);
    
    //[_delegate didScrollToRegion:nwCoord pointSE:seCoord];
    
    ZNSettings *s = [ZNSettings shared];
    [s updateCurrentZone:nwCoord pointSE:seCoord fromTime:nil toTime:nil];
    
    
    //[self updateData];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    ZNMapAnnotationView *av = [[ZNMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([annotation class])];
     
    //av.canShowCallout = YES;
    return av;
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    ZNMapOverlayView *view = [[ZNMapOverlayView alloc] initWithOverlay:overlay];
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation conformsToProtocol:@protocol(ZNMenuView)]) {
        
        [_delegate openMenuFor:(id<ZNMenuView>)view.annotation];
    }
}

#pragma mark DataUpdates

- (void)didFinishRemoteLoad:(BOOL)success {
    NSLog(@"loaded some stuff");
}

- (void)fetchedResults:(NSArray *)results {
    NSMutableArray *annotationsToRemove = [NSMutableArray arrayWithArray:[mapView annotations]];
    for (id o in results) {
        /*
        if ([o conformsToProtocol:@protocol(MKOverlay)]) {
            //
            
            [mapView addOverlay:o];
            
        } else 
        */
        
        if ([o conformsToProtocol:@protocol(MKAnnotation)]) {
            //
            
            [mapView addAnnotation:o];
            [annotationsToRemove removeObject:o];
        }
    }
    [mapView removeAnnotations:annotationsToRemove];
}

- (void)fetchedResultsChangeInsert:(id)object {
    if ([object conformsToProtocol:@protocol(MKAnnotation)]) {
        //
        [mapView addAnnotation:object];
    }
}

- (void)fetchedResultsChangeDelete:(id)object {
    if ([object conformsToProtocol:@protocol(MKAnnotation)]) {
        //
        [mapView removeAnnotation:object];
    }
}

- (void)fetchedResultsChangeUpdate:(id)object {
    NSLog(@"something updated?!");
}



- (void)updateData {
    Zone *z = [_delegate getCurrentZone];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy-MM-dd HH:00";
    
    NSString *fromString = [df stringFromDate:z.fromTime];
    NSString *toString = [df stringFromDate:z.toTime];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/events?longitudeNW=%f&latitudeNW=%f&longitudeSE=%f&latitudeSE=%f&fromTime=%@&toTime=%@", z.pointNW.longitude, z.pointNW.latitude, z.pointSE.longitude, z.pointSE.latitude, fromString, toString];
    
    NSLog(@"resourcepath = %@", resourcePath);
    
    if (!objectLoader) {
        objectLoader = [[ZNObjectLoader alloc] initWithResourcePath:resourcePath andDelegate:self];
    } else {
        [objectLoader changeResourcePath:resourcePath];
    }
    
                              //@"/events?longitudeNW=-180.0&latitudeNW=-180.0&longitudeSE=180.0&latitudeSE=180.0&fromTime=01-01-2000 00:00:00&toTime=01-01-2020 00:00:00"
                              
    /*
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    NSArray *objects = [self.fetchedResultsController fetchedObjects];
    
    for (id o in objects) {
        if ([o conformsToProtocol:@protocol(MKAnnotation)]) {
            //
            
            [mapView addAnnotation:o];
            
        }
    }
    
    
    NSLog(@"got %@", objects);
    */
    
}

#pragma mark MenuView

- (NSDictionary*)menuGroups {
    
    ZNMenuItem *i = [[ZNMenuItem alloc] init];
    i.title = @"test map menu item";
    
    NSArray *items = [NSArray arrayWithObject:i];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:items, @"Test Group", nil];
    
    NSMutableDictionary *allGroups = [NSMutableDictionary dictionaryWithDictionary:[super standardMenuGroups]];
    [allGroups addEntriesFromDictionary:d];
    
    return allGroups;
    
}


#pragma mark Notifications

- (void)didLoadObject:(NSNotification*)notification {
    id object = notification.object;
    
    if ([object conformsToProtocol:@protocol(ZNMapView)]) {
        [self showAnnotationsForObject:object];
    }
}

- (void)didSelectObject:(NSNotification*)notification {
    
    id object = notification.object;
    
    if ([object conformsToProtocol:@protocol(ZNMapView)]) {
        NSLog(@"new selection is map compat");
        if ([object isKindOfClass:[Event class]]) {
            // zoom to this event
            NSLog(@"wow we selected an event");
            
            Event *event = (Event*)object;
            
            
            MKMapPoint nw = MKMapPointForCoordinate(CLLocationCoordinate2DMake([event.latitudeNW floatValue], [event.longitudeNW floatValue]));
            MKMapPoint se = MKMapPointForCoordinate(CLLocationCoordinate2DMake([event.latitudeSE floatValue], [event.longitudeSE floatValue]));
            
            MKMapRect rect = MKMapRectMake(nw.x, nw.y, (se.x - nw.x), (se.y - nw.y));
            
            [mapView setVisibleMapRect:rect animated:YES];
            
            
        }
        
        [self showAnnotationsForObject:object];
    }
    
}


#pragma mark FetchRequestControllerDelegate

/*
- (NSFetchedResultsController*)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fr = [[RKObjectManager sharedManager].mappingProvider fetchRequestForResourcePath:@"/events?longitudeNW=-180.0&latitudeNW=-180.0&longitudeSE=180.0&latitudeSE=180.0&fromTime=01-01-2000 00:00:00&toTime=01-01-2020 00:00:00"];
    
    fr.sortDescriptors = [NSArray array];
    
    NSManagedObjectContext *moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  Event+Timeline.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "Event+Interface.h"
#import "EventLocation+Interface.h"
#import "ZNMenuItem.h"
#import "ZNSettings.h"

@implementation Event (Timeline)

#pragma mark Timeline Protocol

- (NSArray*)rows {
    return [self.eventLocations allObjects];
}

/*
- (NSDate*)startTime {
    return self.startTime;
}

- (NSDate*)endTime {
    return self.endTime;
}
*/

#pragma mark MKAnnotation Protocol

- (NSString*)title {
    return self.name;
}

- (NSString*)subtitle {
    return @"";
}

- (CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake(([self.latitudeSE floatValue] + [self.latitudeNW floatValue]) / 2.0f, ([self.longitudeSE floatValue] + [self.longitudeNW floatValue]) / 2.0f);
}

#pragma mark MKOverlay Protocol

- (MKMapRect)boundingMapRect
{
    // Compute the boundingMapRect given the origin, the gridSize and the grid width and height
    
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake([self.latitudeNW floatValue], [self.longitudeNW floatValue]));
    
    MKMapPoint lowerRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake([self.latitudeNW floatValue], [self.longitudeNW floatValue]));
    
    
    
    double width = lowerRight.x - upperLeft.x;
    double height = lowerRight.y - upperLeft.y;
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, width, height);
    return bounds;
}

#pragma mark PinView Protocol

- (NSString*)imageName {
    return @"zOwnr.png";
}

#pragma mark MenuView

- (NSDictionary*)menuGroups {
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    ZNSettings *s = [ZNSettings shared];
    
    if (![s.currentSelection isEqual:self]) {
        // event is not selected
        [menuItems addObject:[[ZNMenuItem alloc] initWithTitle:@"Select Event" andTarget:kMenuTargetSettings andSelector:@selector(setCurrentSelection:) andSelected:self]];
    } else {
        // event is selected
        [menuItems addObject:[[ZNMenuItem alloc] initWithTitle:@"Show timeline" andTarget:kMenuTargetSettings andSelector:@selector(setCurrentSelection:) andSelected:self]];
    }
    
    
    //ZNMenuItem *i = [[ZNMenuItem alloc] initWithTitle:@"Go to this event" andTarget:kMenuTargetSettings andSelector:@selector(openEvent:) andSelected:self];
    
    
    //NSArray *items = [NSArray arrayWithObject:i];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:menuItems, self.name, nil];
    
    return d;
}

@end

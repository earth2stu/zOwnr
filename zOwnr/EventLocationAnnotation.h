//
//  EventLocationAnnotation.h
//  zOwnr
//
//  Created by Stuart Watkins on 19/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EventLocation.h"

@interface EventLocationAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    EventLocation *location;
    
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) EventLocation *location;

- (id)initWithLocation:(EventLocation*)location;
- (CLLocationCoordinate2D)coordinate;
@end

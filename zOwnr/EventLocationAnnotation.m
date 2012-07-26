//
//  EventLocationAnnotation.m
//  zOwnr
//
//  Created by Stuart Watkins on 19/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventLocationAnnotation.h"

@implementation EventLocationAnnotation

@synthesize location = _location, coordinate = _coordinate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithLocation:(EventLocation*)l{
	if(self = [super init]){

        
        
        _location = l;
		_coordinate = CLLocationCoordinate2DMake([_location.latitudeNW doubleValue], [_location.longitudeNW doubleValue]);
		
		//NSLog(@"Newly created facility at %f,%f", _location.latitudeNW, _location.longitudeNW);
	}
	return self;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return _location.name;
}

// optional
- (NSString *)subtitle
{
    return _location.description;
}




@end

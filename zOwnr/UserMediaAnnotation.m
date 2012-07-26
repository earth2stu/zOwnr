//
//  UserMediaAnnotation.m
//  zOwnr
//
//  Created by Stuart Watkins on 19/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "UserMediaAnnotation.h"
#import "EventItem.h"
#import "EventLocation.h"

@implementation UserMediaAnnotation

@synthesize userMedia = _userMedia, coordinate = _coordinate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithUserMedia:(UserMedia*)um{
	if(self = [super init]){
        
        
        
        _userMedia = um;
		_coordinate = CLLocationCoordinate2DMake([_userMedia.eventItem.eventLocation.latitudeNW doubleValue], [_userMedia.eventItem.eventLocation.longitudeNW doubleValue]);
		
		//NSLog(@"Newly created facility at %f,%f", _location.latitudeNW, _location.longitudeNW);
	}
	return self;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return @"";
}

// optional
- (NSString *)subtitle
{
    return @"";
}





@end

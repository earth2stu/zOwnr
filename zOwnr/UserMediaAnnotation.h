//
//  UserMediaAnnotation.h
//  zOwnr
//
//  Created by Stuart Watkins on 19/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "UserMedia.h"

@interface UserMediaAnnotation : NSObject <MKAnnotation> {

CLLocationCoordinate2D coordinate;
UserMedia *userMedia;

}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UserMedia *userMedia;

- (id)initWithUserMedia:(UserMedia*)um;
- (CLLocationCoordinate2D)coordinate;
@end

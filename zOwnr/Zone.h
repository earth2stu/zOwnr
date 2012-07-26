//
//  Zone.h
//  zOwnr
//
//  Created by Stuart Watkins on 24/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Zone : NSObject

@property (assign) CLLocationCoordinate2D pointNW;
@property (assign) CLLocationCoordinate2D pointSE;
@property (nonatomic, retain) NSDate *fromTime;
@property (nonatomic, retain) NSDate *toTime;

@end

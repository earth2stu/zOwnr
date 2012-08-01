//
//  EventGroup.m
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventGroup.h"



@implementation EventGroup

@synthesize events;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark ZNTimelineViewDelegate

- (NSDate*)startTime {
    return self.fromTime;
}

- (NSDate*)endTime {
    return self.toTime;
}

- (NSArray*)rows {
    return events;
}

#pragma mark ZNMapViewDelegate

- (NSArray*)annotations {
    ZNObjectLoader *loader = [self objectLoaderWithDelegate:nil];
    return [loader localResults];
}

#pragma mark ZNLoadable

- (ZNObjectLoader*)objectLoaderWithDelegate:(id<ZNObjectLoaderDelegate>)delegate {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy-MM-dd HH:00";
    
    NSString *fromString = [df stringFromDate:self.fromTime];
    NSString *toString = [df stringFromDate:self.toTime];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/events?longitudeNW=%f&latitudeNW=%f&longitudeSE=%f&latitudeSE=%f&fromTime=%@&toTime=%@", self.pointNW.longitude, self.pointNW.latitude, self.pointSE.longitude, self.pointSE.latitude, fromString, toString];
    
    return [[ZNObjectLoader alloc] initWithResourcePath:resourcePath andDelegate:delegate];
    
}

@end

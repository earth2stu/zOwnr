//
//  EventLocation+Timeline.m
//  zOwnr
//
//  Created by Stuart Watkins on 22/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventLocation+Interface.h"

@implementation EventLocation (Timeline)

#pragma mark TimelineRowView Protocol

- (NSArray*)cells {
    return [self.eventItems allObjects];
}

- (NSDate*)startTime {
    
}

- (NSDate*)endTime {
    
}

#pragma mark PinView Protocol

- (NSString*)imageName {
    return @"facility_music.png";
}

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

@end

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

- (NSArray*)rows {
    return events;
}

#pragma mark ZNMapViewDelegate

- (NSArray*)annotations {
    return nil;
}

@end

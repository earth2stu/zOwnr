//
//  ZN3DEventLocation.m
//  zOwnr
//
//  Created by Stuart Watkins on 16/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZN3DEventLocation.h"
#import "EventLocation.h"

@implementation ZN3DEventLocation {
    EventLocation *eventLocation;
    NSMutableArray *eventItems;
}

- (id)initWithEventLocation:(id)theLocation atOrigin:(GLKVector3)theOrigin onScene:(ZN3DTimelineViewController *)theScene {
   
    self = [super init];
    if (self) {
        eventLocation = theLocation;
        origin = theOrigin;
        scene = theScene;
        
        eventItems = [[NSMutableArray alloc] init];
        
        int i = 0;
        for (EventItem *eventItem in eventLocation.eventItems) {
            //ZN3DEventItemObject *o = [[ZN3DEventItemObject alloc] ini
            ZN3DEventItemObject *o = [[ZN3DEventItemObject alloc] initWithEventItem:eventItem atLocationOrigin:GLKVector3Make(origin.x + (i * 70), origin.y, origin.z) onScene:scene atSize:GLKVector3Make(50, 0, 30)];
            [eventItems addObject:o];
            i++;
        }
    }
    return self;
    
}

- (void)updateAllWithDelta:(NSNumber*)aDelta {
    [eventItems makeObjectsPerformSelector:@selector(updateWithDelta:) withObject:aDelta];
}

- (void)renderAll {
    [eventItems makeObjectsPerformSelector:@selector(render)];
}


@end

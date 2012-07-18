//
//  Event.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventLocation;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSDecimalNumber * latitudeNW;
@property (nonatomic, retain) NSDecimalNumber * latitudeSE;
@property (nonatomic, retain) NSDecimalNumber * longitudeNW;
@property (nonatomic, retain) NSDecimalNumber * longitudeSE;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSSet *eventLocations;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEventLocationsObject:(EventLocation *)value;
- (void)removeEventLocationsObject:(EventLocation *)value;
- (void)addEventLocations:(NSSet *)values;
- (void)removeEventLocations:(NSSet *)values;
@end

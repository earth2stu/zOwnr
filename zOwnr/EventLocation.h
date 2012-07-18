//
//  EventLocation.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, EventItem;

@interface EventLocation : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * eventLocationID;
@property (nonatomic, retain) NSDecimalNumber * latitudeNW;
@property (nonatomic, retain) NSDecimalNumber * latitudeSE;
@property (nonatomic, retain) NSDecimalNumber * longitudeNW;
@property (nonatomic, retain) NSDecimalNumber * longitudeSE;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *eventItems;
@end

@interface EventLocation (CoreDataGeneratedAccessors)

- (void)addEventItemsObject:(EventItem *)value;
- (void)removeEventItemsObject:(EventItem *)value;
- (void)addEventItems:(NSSet *)values;
- (void)removeEventItems:(NSSet *)values;
@end

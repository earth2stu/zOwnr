//
//  EventItem.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventLocation;

@interface EventItem : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * eventItemID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * eventLocationID;
@property (nonatomic, retain) EventLocation *eventLocation;
@property (nonatomic, retain) NSSet *userMedia;
@end

@interface EventItem (CoreDataGeneratedAccessors)

- (void)addUserMediaObject:(NSManagedObject *)value;
- (void)removeUserMediaObject:(NSManagedObject *)value;
- (void)addUserMedia:(NSSet *)values;
- (void)removeUserMedia:(NSSet *)values;
@end

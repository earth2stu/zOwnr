//
//  ZownrService.m
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZownrService.h"

#import "Event.h"
#import "EventItem.h"
#import "EventLocation.h"
#import "User.h"
#import "UserMedia.h"

//#import "ZNObjectCache.h"

//#import <RestKit/RestKit.h>
//#import <RestKit/CoreData/CoreData.h>

@implementation ZownrService

+ (ZownrService *)sharedInstance
{
    static ZownrService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZownrService alloc] init];
        // Do any other initialisation stuff here
        
    });
    return sharedInstance;
}

- (void)initModel {
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://api2.zownr.com"];
    [RKObjectManager setSharedManager:objectManager];
    
    
    //[RKReachabilityObserver reachabilityObserverForHost:@"http://api2.zownr.com"];
    
    
    
    // create store
    
    RKManagedObjectStore *store = [RKManagedObjectStore objectStoreWithStoreFilename:@"zownr6.sqlite"];
    objectManager.objectStore = store;
    
    //RKManagedObjectMapping *eventMapping = [RKManagedObjectMapping mappingForClass:[Event class] inManagedObjectStore:store];
    
    
    [RKObjectManager sharedManager].objectStore.cacheStrategy = 
    [RKInMemoryManagedObjectCache new];
    
   // [[objectManager client]
   //  setCachePolicy:(RKRequestCachePolicyLoadIfOffline|RKRequestCachePolicyLoadOnError)];
    [[objectManager client] setCachePolicy:RKRequestCachePolicyEnabled];
    
    [RKObjectMapping addDefaultDateFormatter:[RKDotNetDateFormatter dotNetDateFormatter]];
    
    RKManagedObjectMapping *eventMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Event" inManagedObjectStore:store];
    
    
    
    
    
    
    //[eventMapping mappingForSourceKeyPath:@"Events"];
    
    [eventMapping mapKeyPath:@"eventID" toAttribute:@"eventID"];
    [eventMapping mapKeyPath:@"name" toAttribute:@"name"];
    [eventMapping mapKeyPath:@"latitudeNW" toAttribute:@"latitudeNW"];
    [eventMapping mapKeyPath:@"longitudeNW" toAttribute:@"longitudeNW"];
    [eventMapping mapKeyPath:@"latitudeSE" toAttribute:@"latitudeSE"];
    [eventMapping mapKeyPath:@"longitudeSE" toAttribute:@"longitudeSE"];
    [eventMapping mapKeyPath:@"startTime" toAttribute:@"startTime"];
    [eventMapping mapKeyPath:@"endTime" toAttribute:@"endTime"];
    [eventMapping setPrimaryKeyAttribute:@"eventID"];
    eventMapping.setNilForMissingRelationships = NO;
    eventMapping.dateFormatters = [NSArray arrayWithObject: [RKDotNetDateFormatter dotNetDateFormatter]]; 
    
    
    
    
    
    
    
    
    
    // EVENTLOCATION
    RKManagedObjectMapping* eventLocationMapping = [RKManagedObjectMapping mappingForEntityWithName:@"EventLocation" inManagedObjectStore:objectManager.objectStore];
    eventLocationMapping.primaryKeyAttribute = @"eventLocationID";
    [eventLocationMapping mapKeyPath:@"eventLocationID" toAttribute:@"eventLocationID"];
    [eventLocationMapping mapKeyPath:@"name" toAttribute:@"name"];
    [eventLocationMapping mapKeyPath:@"description" toAttribute:@"desc"];
    [eventLocationMapping mapKeyPath:@"latitudeNW" toAttribute:@"latitudeNW"];
    [eventLocationMapping mapKeyPath:@"longitudeNW" toAttribute:@"longitudeNW"];
    [eventLocationMapping mapKeyPath:@"latitudeSE" toAttribute:@"latitudeSE"];
    [eventLocationMapping mapKeyPath:@"longitudeSE" toAttribute:@"longitudeSE"];
    eventLocationMapping.setNilForMissingRelationships = NO;
    
    //    [eventMapping hasMany:@"eventLocations" withMapping:eventLocationMapping];
    //    [eventLocationMapping connectRelationship:@"event" withObjectForPrimaryKeyAttribute:@"eventID"];
    
    
    
    // EVENTLOCATION TO EVENT PARENT MAPPING
    // map the EventID from JSON to eventID NSNumber on object
    [eventLocationMapping mapKeyPath:@"eventID" toAttribute:@"eventID"];
    // connect the event Core Data relationship to the eventID number
    [eventLocationMapping connectRelationship:@"event" withObjectForPrimaryKeyAttribute:@"eventID"];
    // assign the Event mapping object to the "event" Core Data relationship
    [eventLocationMapping mapRelationship:@"event" withMapping:eventMapping];
    
    
    [eventMapping mapKeyPath:@"eventLocations" toRelationship:@"eventLocations" withMapping:eventLocationMapping];
    
    
    
    // EVENT TO EVENTLOCATION TO-MANY MAPPING
    //[eventMapping hasMany:@"eventLocations" withMapping:eventLocationMapping];
    
    // USE EVENTlocation FOR THESE PATHS
    //[objectManager.mappingProvider setMapping:eventLocationMapping forKeyPath:@"EventLocation"];
    //[objectManager.mappingProvider setMapping:eventLocationMapping forKeyPath:@"EventLocations"];
    
    
    
    // EVENTITEM
    RKManagedObjectMapping* eventItemMapping = [RKManagedObjectMapping mappingForEntityWithName:@"EventItem" inManagedObjectStore:objectManager.objectStore];
    eventItemMapping.primaryKeyAttribute = @"eventItemID";
    [eventItemMapping mapKeyPath:@"eventItemID" toAttribute:@"eventItemID"];
    [eventItemMapping mapKeyPath:@"name" toAttribute:@"name"];
    [eventItemMapping mapKeyPath:@"description" toAttribute:@"desc"];
    [eventItemMapping mapKeyPath:@"startTime" toAttribute:@"startTime"];
    [eventItemMapping mapKeyPath:@"endTime" toAttribute:@"endTime"];
    eventItemMapping.setNilForMissingRelationships = NO;
    eventItemMapping.dateFormatters = [NSArray arrayWithObject: [RKDotNetDateFormatter dotNetDateFormatter]]; 
    
    // EVENTITEM TO EVENTLOCATION PARENT MAPPING
    // map the EventLocationID from JSON to eventLocationID NSNumber on object
    [eventItemMapping mapKeyPath:@"eventLocationID" toAttribute:@"eventLocationID"];
    // connect the eventLocation Core Data relationship to the eventLocationID number
    [eventItemMapping connectRelationship:@"eventLocation" withObjectForPrimaryKeyAttribute:@"eventLocationID"];
    // assign the EventLocation mapping object to the "eventLocation" Core Data relationship
    [eventItemMapping mapRelationship:@"eventLocation" withMapping:eventLocationMapping];
    
    [eventLocationMapping mapKeyPath:@"eventItems" toRelationship:@"eventItems" withMapping:eventItemMapping];
    

    
    
    // USER MEDIA
    RKManagedObjectMapping *userMediaMapping = [RKManagedObjectMapping mappingForEntityWithName:@"UserMedia" inManagedObjectStore:objectManager.objectStore];
    userMediaMapping.primaryKeyAttribute = @"userMediaID";
    [userMediaMapping mapKeyPath:@"userMediaID" toAttribute:@"userMediaID"];
    [userMediaMapping mapKeyPath:@"caption" toAttribute:@"caption"];
    [userMediaMapping mapKeyPath:@"captureTime" toAttribute:@"captureTime"];
    
    userMediaMapping.dateFormatters = [NSArray arrayWithObject: [RKDotNetDateFormatter dotNetDateFormatter]]; 
    
    userMediaMapping.setNilForMissingRelationships = NO;
    
    // connect to parent - eventItem
    [userMediaMapping mapKeyPath:@"eventItemID" toAttribute:@"eventItemID"];
    [userMediaMapping connectRelationship:@"eventItem" withObjectForPrimaryKeyAttribute:@"eventItemID"];
    //[userMediaMapping mapRelationship:@"eventItem" withMapping:eventItemMapping];
    [userMediaMapping mapKeyPath:@"eventItem" toRelationship:@"eventItem" withMapping:eventItemMapping serialize:NO];
    //[eventItemMapping mapKeyPath:@"userMediaID" toRelationship:@"userMedia" withMapping:userMediaMapping serialize:NO];
    
    // setup reverse mappings
    [[objectManager mappingProvider] setSerializationMapping:[userMediaMapping inverseMapping] forClass:[UserMedia class]];
    [objectManager.router routeClass:[UserMedia class] toResourcePath:@"/usermedia" forMethod:RKRequestMethodPOST];

    
    
    [objectManager.mappingProvider setObjectMapping:userMediaMapping
                             forResourcePathPattern:@"/eventItems/:eventItemID/usermedia"
                              withFetchRequestBlock:^ (NSString *resourcePath) {
                                  NSFetchRequest *fr = [UserMedia fetchRequest];
                                  
                                  // get the eventID from the resourcePath
                                  SOCPattern* soc = [SOCPattern patternWithString:@"/eventItems/:eventItemID/usermedia"];
                                  NSDictionary* theEventItem = [soc parameterDictionaryFromSourceString:resourcePath];
                                  NSString *eventItemID = [theEventItem valueForKey:@"eventItemID"];
                                  
                                  // set up the predicate
                                  fr.predicate = [NSPredicate predicateWithFormat:@"eventItemID = %@", eventItemID];
                                  return fr;
                                  
                                  
                              }];

    [objectManager.mappingProvider setObjectMapping:userMediaMapping forResourcePathPattern:@"/usermedia"];
    
    [objectManager.mappingProvider setObjectMapping:eventMapping
                             forResourcePathPattern:@"/events/:eventID"
                              withFetchRequestBlock:^ (NSString *resourcePath) {
                                  NSFetchRequest *fr = [Event fetchRequest];
                                  
                                  // get the eventID from the resourcePath
                                  SOCPattern* soc = [SOCPattern patternWithString:@"/events/:eventID"];
                                  NSDictionary* theEvent = [soc parameterDictionaryFromSourceString:resourcePath];
                                  NSString *eventID = [theEvent valueForKey:@"eventID"];
                                  
                                  // set up the predicate
                                  fr.predicate = [NSPredicate predicateWithFormat:@"eventID = %@", eventID];
                                  return fr;
                                  
                              }];
    
    [objectManager.mappingProvider setObjectMapping:eventMapping
                             forResourcePathPattern:@"/events"
                              withFetchRequestBlock:^ (NSString *resourcePath) {
                                  return [Event fetchRequest];
                              }];
    
    
        
    
    

}

/*

- (void)initModel  {
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://api.zownr.com"];
    
    // Enable automatic network activity indicator management
    //[RKRequestQueue sharedQueue].showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Initialize object store
    
    NSString *databaseName = @"zOwnr.sqlite";
    
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName usingSeedDatabaseName:nil managedObjectModel:nil delegate:self];
    
    
    
    
    // set up the cache for offline usage
    ZNObjectCache* cache = [[ZNObjectCache alloc] init];
    [RKObjectManager sharedManager].objectStore.managedObjectCache = cache;
    
    // Setup our object mappings    
    /*!
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back Twitter user objects directly onto NSManagedObject instances --
     there is no backing model class!
     *
    
    
    // USER
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForEntityWithName:@"User"];
    userMapping.primaryKeyAttribute = @"userID";
    [userMapping mapKeyPath:@"ID" toAttribute:@"userID"];
    [userMapping mapKeyPath:@"EmailAddress" toAttribute:@"emailAddress"];
    [userMapping mapKeyPath:@"FirstName" toAttribute:@"firstName"];
    [userMapping mapKeyPath:@"Surname" toAttribute:@"surname"];
    [userMapping mapKeyPath:@"FacebookID" toAttribute:@"facebookID"];
    
    //[userMapping mapAttributes:@"name", nil];
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"User"];
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"Users"];
    //[objectManager.mappingProvider setMapping:userMapping forKeyPath:@"Friend"];
    
    
    // EVENT
    RKManagedObjectMapping* eventMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Event"];
    eventMapping.primaryKeyAttribute = @"eventID";
    [eventMapping mapKeyPath:@"ID" toAttribute:@"eventID"];
    [eventMapping mapKeyPath:@"Name" toAttribute:@"name"];
    // USE EVENT FOR THESE PATHS
    [objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"Event"];
    [objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"Events"];
    
    // EVENTLOCATION
    RKManagedObjectMapping* eventLocationMapping = [RKManagedObjectMapping mappingForEntityWithName:@"EventLocation"];
    eventLocationMapping.primaryKeyAttribute = @"eventLocationID";
    [eventLocationMapping mapKeyPath:@"ID" toAttribute:@"eventLocationID"];
    [eventLocationMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [eventLocationMapping mapKeyPath:@"Description" toAttribute:@"desc"];
    
    // EVENTLOCATION TO EVENT PARENT MAPPING
    // map the EventID from JSON to eventID NSNumber on object
    [eventLocationMapping mapKeyPath:@"EventID" toAttribute:@"eventID"];
    // connect the event Core Data relationship to the eventID number
    [eventLocationMapping connectRelationship:@"event" withObjectForPrimaryKeyAttribute:@"eventID"];
    // assign the Event mapping object to the "event" Core Data relationship
    [eventLocationMapping mapRelationship:@"event" withMapping:eventMapping];
    
    
    [eventMapping mapKeyPath:@"EventLocations" toRelationship:@"eventLocations" withMapping:eventLocationMapping];
    
    // EVENT TO EVENTLOCATION TO-MANY MAPPING
    //[eventMapping hasMany:@"eventLocations" withMapping:eventLocationMapping];
    
    // USE EVENTlocation FOR THESE PATHS
    //[objectManager.mappingProvider setMapping:eventLocationMapping forKeyPath:@"EventLocation"];
    //[objectManager.mappingProvider setMapping:eventLocationMapping forKeyPath:@"EventLocations"];
    
    
    
    // EVENTITEM
    RKManagedObjectMapping* eventItemMapping = [RKManagedObjectMapping mappingForEntityWithName:@"EventItem"];
    eventItemMapping.primaryKeyAttribute = @"eventItemID";
    [eventItemMapping mapKeyPath:@"ID" toAttribute:@"eventItemID"];
    [eventItemMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [eventItemMapping mapKeyPath:@"Description" toAttribute:@"desc"];
    
    // EVENTITEM TO EVENTLOCATION PARENT MAPPING
    // map the EventLocationID from JSON to eventLocationID NSNumber on object
    [eventItemMapping mapKeyPath:@"EventLocationID" toAttribute:@"eventLocationID"];
    // connect the eventLocation Core Data relationship to the eventLocationID number
    [eventItemMapping connectRelationship:@"eventLocation" withObjectForPrimaryKeyAttribute:@"eventLocationID"];
    // assign the EventLocation mapping object to the "eventLocation" Core Data relationship
    [eventItemMapping mapRelationship:@"eventLocation" withMapping:eventLocationMapping];
    
    [eventLocationMapping mapKeyPath:@"EventItems" toRelationship:@"eventItems" withMapping:eventItemMapping];
    
    // EVENTLOCATION TO EVENTITEM TO-MANY MAPPING - core data rel name
    //[eventLocationMapping hasMany:@"eventItems" withMapping:eventItemMapping];
    
    // USE EVENTITEM FOR THESE PATHS
    //[objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"EventItem"];
    //[objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"EventItems"];
    
    
    // USEREVENTITEM
    RKManagedObjectMapping* userEventItemMapping = [RKManagedObjectMapping mappingForEntityWithName:@"UserEventItem"];
    userEventItemMapping.primaryKeyAttribute = @"userEventItemID";
    [userEventItemMapping mapKeyPath:@"ID" toAttribute:@"userEventItemID"];
    [userEventItemMapping mapKeyPath:@"UserID" toAttribute:@"userID"];
    [userEventItemMapping mapKeyPath:@"EventItemID" toAttribute:@"eventItemID"];
    
    // USEREVENTITEM TO EVENTITEM PARENT MAPPING
    // connect the eventLocation Core Data relationship to the eventLocationID number
    [userEventItemMapping connectRelationship:@"eventItem" withObjectForPrimaryKeyAttribute:@"eventItemID"];
    // assign the EventLocation mapping object to the "eventLocation" Core Data relationship
    [userEventItemMapping mapRelationship:@"eventItem" withMapping:eventItemMapping];
    
    [eventItemMapping mapKeyPath:@"UserEventItems" toRelationship:@"userEventItems" withMapping:userEventItemMapping];
    
    // EVENTITEM TO USEREVENTITEM TO-MANY MAPPING
    //[eventItemMapping hasMany:@"userEventItems" withMapping:userEventItemMapping];
    
    
    // USEREVENTITEM TO USER PARENT MAPPING
    [userEventItemMapping connectRelationship:@"user" withObjectForPrimaryKeyAttribute:@"userID"];
    // assign the EventLocation mapping object to the "eventLocation" Core Data relationship
    [userEventItemMapping mapRelationship:@"user" withMapping:userMapping];
    
    [userMapping mapKeyPath:@"UserEventItems" toRelationship:@"userEventItems" withMapping:userEventItemMapping];
    
    
    
    // FRIEND
    RKManagedObjectMapping* friendMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Friend"];
    friendMapping.primaryKeyAttribute = @"friendID";
    [friendMapping mapKeyPath:@"ID" toAttribute:@"friendID"];
    [friendMapping mapKeyPath:@"FullName" toAttribute:@"fullName"];
    [friendMapping mapKeyPath:@"LatestLatitude" toAttribute:@"latitude"];
    [friendMapping mapKeyPath:@"LatestLongitude" toAttribute:@"longitude"];
    [friendMapping mapKeyPath:@"FacebookID" toAttribute:@"facebookID"];
    
    // FRIEND to USER parent mapping
    [friendMapping connectRelationship:@"user" withObjectForPrimaryKeyAttribute:@"userID"];
    [friendMapping mapRelationship:@"user" withMapping:userMapping];
    
    // map Friends collection on User to Friend object
    [userMapping mapKeyPath:@"Friends" toRelationship:@"friends" withMapping:friendMapping];
    
    // Friends collection to Friend object mapping
    [objectManager.mappingProvider setMapping:friendMapping forKeyPath:@"Friend"];
    [objectManager.mappingProvider setMapping:friendMapping forKeyPath:@"Friends"];
    
    
    
    
    
    
    
    // FRIENDEVENTITEM
    RKManagedObjectMapping* friendEventItemMapping = [RKManagedObjectMapping mappingForEntityWithName:@"FriendEventItem"];
    friendEventItemMapping.primaryKeyAttribute = @"friendEventItemID";
    [friendEventItemMapping mapKeyPath:@"ID" toAttribute:@"friendEventItemID"];
    [friendEventItemMapping mapKeyPath:@"FriendID" toAttribute:@"friendID"];
    [friendEventItemMapping mapKeyPath:@"EventItemID" toAttribute:@"eventItemID"];
    
    // USEREVENTITEM TO EVENTITEM PARENT MAPPING
    // connect the eventLocation Core Data relationship to the eventLocationID number
    [friendEventItemMapping connectRelationship:@"eventItem" withObjectForPrimaryKeyAttribute:@"eventItemID"];
    // assign the EventLocation mapping object to the "eventLocation" Core Data relationship
    [friendEventItemMapping mapRelationship:@"eventItem" withMapping:eventItemMapping];
    
    [eventItemMapping mapKeyPath:@"FriendEventItems" toRelationship:@"friendEventItems" withMapping:friendEventItemMapping];
    
    // EVENTITEM TO USEREVENTITEM TO-MANY MAPPING
    //[eventItemMapping hasMany:@"userEventItems" withMapping:userEventItemMapping];
    
    
    // USEREVENTITEM TO USER PARENT MAPPING
    [friendEventItemMapping connectRelationship:@"friend" withObjectForPrimaryKeyAttribute:@"friendID"];
    // assign the EventLocation mapping object to the "eventLocation" Core Data relationship
    [friendEventItemMapping mapRelationship:@"friend" withMapping:friendMapping];
    
    [friendMapping mapKeyPath:@"FriendEventItems" toRelationship:@"friendEventItems" withMapping:friendEventItemMapping];
    
    [objectManager.mappingProvider setMapping:friendEventItemMapping forKeyPath:@"FriendEventItems"];
    
    
    
    
    
    
    
    
    
    // USER TO USEREVENTITEM TO-MANY MAPPING
    //[userMapping hasMany:@"userEventItems" withMapping:userEventItemMapping];
    
    // USE USEREVENTITEMS FOR THESE PATHS
    //[objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"UserEventItem"];
    //[objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"UserEventItems"];
    
    
    
    //[RKObjectManager sharedManager].router routeClass:[ toResourcePath:<#(NSString *)#> forMethod:<#(RKRequestMethod)#>
    
    //[eventLocationMapping hasOne:@"Event" withMapping:eventMapping];
    
    //[objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"Event"];
    
    //[eventMapping mapRelationship:@"Locations" withMapping:eventLocationMapping];
    //[objectManager.mappingProvider setMapping:eventLocationMapping forKeyPath:@"location"];
    //[objectManager.mappingProvider setMapping:eventLocationMapping forKeyPath:@"Location"];
    
    
    //[RKObjectManager sharedManager].router routeClass:[ toResourcePath:@"/account/register" forMethod:RKRequestMethodPOST
/*    
    // REGISTER USER OBJECT
    RKObjectMapping *registerMapping = [RKObjectMapping mappingForClass:[RegisterUser class]];
    [registerMapping mapKeyPath:@"EmailAddress" toAttribute:@"emailAddress"];
    [registerMapping mapKeyPath:@"Password" toAttribute:@"password"];
    [registerMapping mapKeyPath:@"FirstName" toAttribute:@"firstName"];
    [registerMapping mapKeyPath:@"Surname" toAttribute:@"surname"];
    [[objectManager mappingProvider] setSerializationMapping:[registerMapping inverseMapping] forClass:[RegisterUser class]];
    [[RKObjectManager sharedManager].router routeClass:[RegisterUser class] toResourcePath:@"/account/register" forMethod:RKRequestMethodPOST];
    
    // LOGIN USER OBJECT
    RKObjectMapping *loginMapping = [RKObjectMapping mappingForClass:[LoginUser class]];
    [loginMapping mapKeyPath:@"EmailAddress" toAttribute:@"emailAddress"];
    [loginMapping mapKeyPath:@"Password" toAttribute:@"password"];
    [[objectManager mappingProvider] setSerializationMapping:[loginMapping inverseMapping] forClass:[LoginUser class]];
    [[RKObjectManager sharedManager].router routeClass:[LoginUser class] toResourcePath:@"/account/login" forMethod:RKRequestMethodPOST];
    
    // FACEBOOK LOGIN USER OBJECT
    RKObjectMapping *fbLoginMapping = [RKObjectMapping mappingForClass:[FBLogin class]];
    [fbLoginMapping mapKeyPath:@"accessToken" toAttribute:@"accessToken"];
    [[objectManager mappingProvider] setSerializationMapping:[fbLoginMapping inverseMapping] forClass:[FBLogin class]];
    [[RKObjectManager sharedManager].router routeClass:[FBLogin class] toResourcePath:@"/account/fblogin" forMethod:RKRequestMethodPOST];
    
    // SESSION OBJECT
    RKObjectMapping *sessionMapping = [RKObjectMapping mappingForClass:[Session class]];
    [sessionMapping mapKeyPath:@"" toAttribute:@"sessionID"];
    [objectManager.mappingProvider setMapping:sessionMapping forKeyPath:@"session"];
    
    // USERLOCATION
    
    RKObjectMapping* userLocationMapping = [RKObjectMapping mappingForClass:[UserLocation class]];
    [userLocationMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [userLocationMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [userLocationMapping mapKeyPath:@"HorizAccuracy" toAttribute:@"horizAccuracy"];
    [[objectManager mappingProvider] setSerializationMapping:[userLocationMapping inverseMapping] forClass:[UserLocation class]];
    
    [[RKObjectManager sharedManager].router routeClass:[UserLocation class] toResourcePath:@"/me/location" forMethod:RKRequestMethodPOST];
* 
    
    
    // [[objectManager client] setValue:@"F04765A808EAB486176C729106B6A6F1FA52155E4364A7FF522BEB5FD0087B020C570095B7CD42686AD6674A8A212D0829C5C834964C5B621B9B981506A6E710CB1B99BE63E91AAC12CBE58772AE127C6A99489927FF40302729D45772C6B06A75A6210A1E489FF9DC9E8011AF6F64F2DDE3EBB373559378C0864BC269E570AE1B6ED6575E87C1A6D48A936A63C40DFD21FB3D609E8EE250285B592A06A05011768360D7B9979E1B82BC44E006B0C834F5DD914CBC022670A71530FA7D4F241B5EF75C56A577675CC737F61CA18459D3" 
    //              forHTTPHeaderField:@"Auth"]; 
    
    
    //NSArray* eventObjects = [Event allObjects];
    
    //NSLog(@"objects cached:%i", [eventObjects count]);
    
    
} */


- (Event*) getEventByID:(NSNumber*)eventID {
    
}


@end

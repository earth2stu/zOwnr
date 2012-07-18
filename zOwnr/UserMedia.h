//
//  UserMedia.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventItem;

@interface UserMedia : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSDate * captureTime;
@property (nonatomic, retain) NSNumber * eventItemID;
@property (nonatomic, retain) NSString * fileGUID;
@property (nonatomic, retain) NSNumber * userMediaID;
@property (nonatomic, retain) EventItem *eventItem;

@end

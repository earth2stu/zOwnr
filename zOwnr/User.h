//
//  User.h
//  zOwnr
//
//  Created by Stuart Watkins on 12/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSNumber * facebookID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSNumber * userID;

@end

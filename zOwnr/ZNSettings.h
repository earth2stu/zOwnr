//
//  ZNSettings.h
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ZNObjectLoader.h"

@protocol ZNSettingsDelegate <NSObject>

//

- (void)setCurrentSelection:(id<ZNSelectable>)currentSelection;

@end

@interface ZNSettings : NSObject <ZNObjectLoaderDelegate> {
    ZNObjectLoader *selectionLoader;
}

+ (ZNSettings*)shared;

@property (nonatomic, retain) id<ZNSettingsDelegate> delegate;

@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) NSString *currentSession;
@property (nonatomic, retain) id<ZNSelectable> currentSelection;

- (BOOL)isCurrentUser;
- (BOOL)isLoggedIn;
- (NSDictionary*)requestHeaders;

@end

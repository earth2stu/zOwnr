//
//  ZNSettings.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNSettings.h"
#import "ZownrService.h"

@implementation ZNSettings

@synthesize delegate;
@synthesize currentUser = _currentUser;
@synthesize currentSession = _currentSession;
@synthesize currentSelection = _currentSelection;
@synthesize currentZone = _currentZone;

+ (ZNSettings *)shared
{
    static ZNSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZNSettings alloc] init];
        // Do any other initialisation stuff here
        
        // load current user
        
        
    });
    return sharedInstance;
}

- (BOOL)isCurrentUser {
    return (_currentUser != nil);
}

- (BOOL)isLoggedIn {
    return (_currentUser != nil);
}

- (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (_currentUser) {
        // save user id if we got one
        [defaults setObject:_currentUser.userID forKey:kZNCurrentUserIDKey];
    } else {
        // remove if we don't
        [defaults removeObjectForKey:kZNCurrentUserIDKey];
    }
    
    [defaults synchronize];
    
}

- (void)setCurrentSession:(NSString *)currentSession {
    _currentSession = currentSession;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (_currentSession) {
        // save session id if we got one
        [defaults setObject:_currentSession forKey:kZNSessionIDKey];
    } else {
        // remove if we don't
        [defaults removeObjectForKey:kZNSessionIDKey];
    }
    
    [defaults synchronize];
}

- (void)setCurrentSelection:(id<ZNSelectable>)currentSelection {
    _currentSelection = currentSelection;
    //[delegate setCurrentSelection:currentSelection];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kZNChangeSelectionKey object:currentSelection];
    
    if ([currentSelection conformsToProtocol:@protocol(ZNLoadable)]) {
        [[ZownrService sharedInstance] loadObject:(id<ZNLoadable>)currentSelection];
    }
 
}

- (NSDictionary*)requestHeaders {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
    if (_currentSession) {
        [headers setObject:_currentSession forKey:@"auth"];
    }
    return headers;
}

@end

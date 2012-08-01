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
    
    NSLog(@"changed selection notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:kZNChangeSelectionKey object:currentSelection];
    
    if ([currentSelection conformsToProtocol:@protocol(ZNLoadable)]) {
        [[ZownrService sharedInstance] loadObject:(id<ZNLoadable>)currentSelection];
    }
 
}

- (Zone*)currentZone {
    if (!_currentZone) {
        _currentZone = [[Zone alloc] init];
    }
    return _currentZone;
}

- (void)updateCurrentZone:(CLLocationCoordinate2D)pointNW pointSE:(CLLocationCoordinate2D)pointSE fromTime:(NSDate *)fromTime toTime:(NSDate *)toTime {
    if (CLLocationCoordinate2DIsValid(pointNW) && CLLocationCoordinate2DIsValid(pointSE)) {
        self.currentZone.pointNW = pointNW;
        self.currentZone.pointSE = pointSE;
    }
    if (fromTime && toTime) {
        if (fromTime < toTime) {
            self.currentZone.fromTime = fromTime;
            self.currentZone.toTime = toTime;
        }
    }
    
    if (CLLocationCoordinate2DIsValid(self.currentZone.pointNW) && CLLocationCoordinate2DIsValid(self.currentZone.pointSE) && self.currentZone.fromTime && self.currentZone.toTime) {
        NSLog(@"changed zone notification");
        [[NSNotificationCenter defaultCenter] postNotificationName:kZNChangeZoneKey object:self.currentZone];
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

//
//  ZNSettings.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNSettings.h"
#import "ZownrService.h"
#import "EventGroup.h"

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
    
    /*
    if (_currentSelection == nil) {
        // set to a new event group
        EventGroup *eg = [[EventGroup alloc] init];
        eg.fromTime = _currentZone.fromTime;
        eg.toTime = _currentZone.toTime;
        eg.pointNW = _currentZone.pointNW;
        eg.pointSE = _currentZone.pointSE;
        _currentSelection = eg;
    }
    */
    
    NSLog(@"changed selection notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:kZNChangeSelectionKey object:_currentSelection];
    
    //if ([currentSelection conformsToProtocol:@protocol(ZNLoadable)]) {
    //    [[ZownrService sharedInstance] loadObject:(id<ZNLoadable>)currentSelection];
    //}
 
}

- (Zone*)currentZone {
    if (!_currentZone) {
        _currentZone = [[Zone alloc] init];
    }
    return _currentZone;
}

- (void)updateCurrentZoneFromTime:(NSDate*)fromTime toTime:(NSDate*)toTime {
    if (fromTime && toTime) {
        if ([fromTime compare:toTime] == NSOrderedAscending) {
            self.currentZone.fromTime = fromTime;
            self.currentZone.toTime = toTime;
        }
    } else {
        NSLog(@"times not valid");
    }
    [self notifyZoneChangeIfValid];
}

- (void)updateCurrentZoneFromPointNW:(CLLocationCoordinate2D)pointNW toPoint:(CLLocationCoordinate2D)pointSE {
    NSLog(@"update current zone");
    if (CLLocationCoordinate2DIsValid(pointNW) && CLLocationCoordinate2DIsValid(pointSE)) {
        NSLog(@"coordinate is valid");
        self.currentZone.pointNW = pointNW;
        self.currentZone.pointSE = pointSE;
    } else {
        NSLog(@"coordinate not valid");
    }
    [self notifyZoneChangeIfValid];
}

- (void)notifyZoneChangeIfValid {
    if (CLLocationCoordinate2DIsValid(self.currentZone.pointNW) && CLLocationCoordinate2DIsValid(self.currentZone.pointSE) && self.currentZone.fromTime && self.currentZone.toTime) {
        NSLog(@"changed zone notification");
        [[NSNotificationCenter defaultCenter] postNotificationName:kZNChangeZoneKey object:self.currentZone];
        
        if (self.currentSelection == nil || [self.currentSelection isKindOfClass:[EventGroup class]]) {
            // we have no selection or we are already looking at an eventGroup
            EventGroup *eg = [[EventGroup alloc] init];
            eg.fromTime = _currentZone.fromTime;
            eg.toTime = _currentZone.toTime;
            eg.pointNW = _currentZone.pointNW;
            eg.pointSE = _currentZone.pointSE;
            self.currentSelection = eg;
        }
        
    } else {
        NSLog(@"zone set not valid");
    }
}

/*
- (void)updateCurrentZone:(CLLocationCoordinate2D)pointNW pointSE:(CLLocationCoordinate2D)pointSE fromTime:(NSDate *)fromTime toTime:(NSDate *)toTime {
    
        
    
    
}
*/

- (NSDictionary*)requestHeaders {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
    if (_currentSession) {
        [headers setObject:_currentSession forKey:@"auth"];
    }
    return headers;
}

@end

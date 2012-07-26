//
//  ZNSocialView.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNSocialView.h"
#import "ZNMenuItem.h"
#import "ZNAppDelegate.h"
#import "ZNSettings.h"

#import "FBLogin.h"
#import "User.h"
#import "Session.h"

@implementation ZNSocialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor yellowColor];
        
        ZNAppDelegate *app = (ZNAppDelegate*)[[UIApplication sharedApplication] delegate];
        app.facebook = [[Facebook alloc] initWithAppId:@"232014290188966" andDelegate:self];
        facebook = app.facebook;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark MenuView

- (NSDictionary*)menuGroups {
    
    ZNMenuItem *i = [[ZNMenuItem alloc] init];
    i.title = @"test social menu item";
    
    NSArray *items = [NSArray arrayWithObject:i];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:items, @"Test Group", nil];
    
    NSMutableDictionary *allGroups = [NSMutableDictionary dictionaryWithDictionary:[super standardMenuGroups]];
    [allGroups addEntriesFromDictionary:d];
    
    return allGroups;
    
}

#pragma mark MenuActions

- (void)showLogin {
    ZNSocialLoginView *slv = [[ZNSocialLoginView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withDelegate:self];
    [self addSubview:slv];
}

- (void)doLogout {
    [[ZNSettings shared] setCurrentUser:nil];
}

#pragma mark SocialLoginDelegate

- (void)facebookLogin {
    
    NSArray* permissions =  [NSArray arrayWithObjects:
                             @"email", @"read_stream", @"publish_stream", @"offline_access", nil];
    [facebook authorize:permissions];
}

#pragma mark Facebook Delegate

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    FBLogin *f = [[FBLogin alloc] init];
    f.accessToken = [facebook accessToken];
    
    //[[RKObjectManager sharedManager] postObject:f mapResponseWith:nil delegate:self];
    
    
    
    //[[RKObjectManager sharedManager] postObject:f delegate:self];   
    
    [[RKObjectManager sharedManager] postObject:f usingBlock:^(RKObjectLoader *loader) {
        //loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[User class]];
        loader.targetObject = nil;
        loader.delegate = self;
    }];
        
}

#pragma mark ObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"yay");
    
    for (id o in objects) {
        if ([o isKindOfClass:[Session class]]) {
            // got session ID
            NSLog(@"%@", o);
            
            Session *session = (Session*)o;
            
            [[ZNSettings shared] setCurrentSession:session.sessionID];
            
        }
        if ([o isKindOfClass:[User class]]) {
            // got user object
            NSLog(@"%@", o);
            
            User *user = (User*)o;
            [[ZNSettings shared] setCurrentUser:user];
        }
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"error");
}

@end

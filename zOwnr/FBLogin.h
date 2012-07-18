//
//  FBLogin.h
//  zOwnr
//
//  Created by Stuart Watkins on 16/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBLogin : NSObject {
    NSString *accessToken;
}

@property (nonatomic, strong) NSString *accessToken;

@end

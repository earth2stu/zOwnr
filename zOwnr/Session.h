//
//  Session.h
//  zOwnr
//
//  Created by Stuart Watkins on 16/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject {
    NSString *sessionID;
}

@property (nonatomic, strong) NSString *sessionID;

@end

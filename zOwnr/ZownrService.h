//
//  ZownrService.h
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "ZNObjectLoader.h"

@interface ZownrService : NSObject <ZNObjectLoaderDelegate> {
    ZNObjectLoader *loader;
    id<ZNLoadable> loadingObject;

}



+ (ZownrService *)sharedInstance;
- (void)initModel;
- (void)loadObject:(id<ZNLoadable>)object;

@end

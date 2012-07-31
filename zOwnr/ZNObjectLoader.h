//
//  ZNObjectLoader.h
//  zOwnr
//
//  Created by Stuart Watkins on 24/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class ZNObjectLoader;

@protocol ZNObjectLoaderDelegate <NSObject>

@optional

- (void)fetchedResults:(NSArray*)results;
- (void)fetchedResultsChangeInsert:(id)object;
- (void)fetchedResultsChangeDelete:(id)object;
- (void)fetchedResultsChangeUpdate:(id)object;
- (void)didFinishRemoteLoad:(BOOL)success;

@end

@protocol ZNLoadable <NSObject>

- (BOOL)isLoaded;
- (ZNObjectLoader*)objectLoaderWithDelegate:(id<ZNObjectLoaderDelegate>)delegate;

@end

@interface ZNObjectLoader : NSObject <NSFetchedResultsControllerDelegate, RKObjectLoaderDelegate> {
    id<ZNObjectLoaderDelegate> delegate;
    RKObjectLoader *objectLoader;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)changeResourcePath:(NSString*)resourcePath;
- (id)initWithResourcePath:(NSString*)resourcePath andDelegate:(id<ZNObjectLoaderDelegate>)del;
- (void)cancelLoad;

@end

//
//  ZNObjectLoader.m
//  zOwnr
//
//  Created by Stuart Watkins on 24/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNObjectLoader.h"


@interface ZNObjectLoader() {
    //NSFetchedResultsController *_fetchedResultsController;
    NSString *_resourcePath;
}
- (void)doLoad;

@end

@implementation ZNObjectLoader

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithResourcePath:(NSString*)resourcePath andDelegate:(id<ZNObjectLoaderDelegate>)del {
    self = [super init];
    if (self)
    {
        delegate = del;
        _resourcePath = resourcePath;
        
        [self doLoad];
        
    }
    return self;
}

- (void)doLoad {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (self.fetchedResultsController.fetchedObjects) {
        [delegate fetchedResults:self.fetchedResultsController.fetchedObjects];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:_resourcePath delegate:self];
    
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    NSLog(@"loaded more");    
    
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"error");
}

- (NSFetchedResultsController*)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fr = [[RKObjectManager sharedManager].mappingProvider fetchRequestForResourcePath:_resourcePath];
    
    fr.sortDescriptors = [NSArray array];
    
    NSManagedObjectContext *moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}


- (void)changeResourcePath:(NSString *)resourcePath {
    _fetchedResultsController = nil;
    _resourcePath = resourcePath;
    [self doLoad];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [delegate fetchedResultsChangeInsert:anObject];
            break;
            
        case NSFetchedResultsChangeDelete:
            [delegate fetchedResultsChangeDelete:anObject];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [delegate fetchedResultsChangeUpdate:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            //We do nothing here since we are not concerned with the index an object is at
            break;
    }
}


@end

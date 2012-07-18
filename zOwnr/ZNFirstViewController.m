//
//  ZNFirstViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 11/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNFirstViewController.h"
#import "Event.h"
#import "ZNResponseLoader.h"

@implementation ZNFirstViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://api2.zownr.com"];
    [RKObjectManager setSharedManager:objectManager];

    
    //[RKReachabilityObserver reachabilityObserverForHost:@"http://api2.zownr.com"];
    
    // create store
    
    RKManagedObjectStore *store = [RKManagedObjectStore objectStoreWithStoreFilename:@"zownr6.sqlite"];
    objectManager.objectStore = store;
    
    //RKManagedObjectMapping *eventMapping = [RKManagedObjectMapping mappingForClass:[Event class] inManagedObjectStore:store];
    
    RKManagedObjectMapping *eventMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Event" inManagedObjectStore:store];
    

    
    
    
    
    //[eventMapping mappingForSourceKeyPath:@"Events"];
    
    [eventMapping mapKeyPath:@"eventID" toAttribute:@"eventID"];
    [eventMapping mapKeyPath:@"name" toAttribute:@"name"];
    [eventMapping mapKeyPath:@"latitudeNW" toAttribute:@"latitudeNW"];
    [eventMapping mapKeyPath:@"longitudeNW" toAttribute:@"longitudeNW"];
    [eventMapping mapKeyPath:@"latitudeSE" toAttribute:@"latitudeSE"];
    [eventMapping mapKeyPath:@"longitudeSE" toAttribute:@"longitudeSE"];
    [eventMapping mapKeyPath:@"startTime" toAttribute:@"startTime"];
    [eventMapping mapKeyPath:@"endTime" toAttribute:@"endTime"];
    [eventMapping setPrimaryKeyAttribute:@"eventID"];
    
    
    
        [objectManager.mappingProvider setObjectMapping:eventMapping
                                 forResourcePathPattern:@"/events"
                                 withFetchRequestBlock:^ (NSString *resourcePath) {
                                     return [Event fetchRequest];
                                  }];
    
    //[objectManager.mappingProvider setMapping:eventMapping forKeyPath:@"Events"];
    
    */
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    ZNResponseLoader* responseLoader = [ZNResponseLoader responseLoader];
    responseLoader.timeout = 4;
    RKURL *URL = [objectManager.baseURL URLByAppendingResourcePath:@"/events/1"];
    RKManagedObjectLoader *objectLoader = [RKManagedObjectLoader loaderWithURL:URL mappingProvider:objectManager.mappingProvider objectStore:objectManager.objectStore];
    objectLoader.cachePolicy = RKRequestCachePolicyLoadIfOffline;
    objectLoader.cache = [RKRequestCache new];
    objectLoader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
    objectLoader.delegate = responseLoader;
    [objectLoader send];
    [responseLoader waitForResponse];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end

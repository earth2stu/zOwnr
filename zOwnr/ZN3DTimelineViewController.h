//
//  ZN3DTimelineViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 15/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

#import "Event.h"
#import "EventLocation.h"
#import "EventItem.h"



@class ZNAssetManager;
@class Camera;
@class ZN3DEventLocation;

@interface ZN3DTimelineViewController : GLKViewController <RKObjectLoaderDelegate, UIGestureRecognizerDelegate> {
    GLuint              currentBoundTexture;
    ZNAssetManager        *assetManager;
    Camera              *camera;
    
    
    
    // event management
    Event *event;
    NSMutableArray *eventLocations;
    
    
}

@property (nonatomic) GLKMatrix4 sceneModelMatrix;
@property (nonatomic, assign) GLuint currentBoundTexture;
@property (nonatomic, strong) ZNAssetManager *assetManager;
@property (nonatomic, strong) Camera *camera;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)loadEvent;

@end

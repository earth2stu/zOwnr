//
//  ZN3DEventLocation.h
//  zOwnr
//
//  Created by Stuart Watkins on 16/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ZN3DEventItemObject.h"

@interface ZN3DEventLocation : NSObject {
    GLKVector3 origin;
    ZN3DTimelineViewController *scene;
}

- (id)initWithEventLocation:(EventLocation*)theLocation atOrigin:(GLKVector3)theOrigin onScene:(ZN3DTimelineViewController*)theScene;
- (void)updateAllWithDelta:(NSNumber*)aDelta;
- (void)renderAll;

@end

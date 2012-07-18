//
//  ZN3DEventItemObject.h
//  zOwnr
//
//  Created by Stuart Watkins on 16/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNAbstractObject.h"
#import "ZN3DTimelineViewController.h"
#import "EventItem.h"
#import "EventItemModel.h"
#import "SquareModel.h"

@interface ZN3DEventItemObject : ZNAbstractObject {
    EventItem *eventItem;
    GLKVector3 origin;
    ZN3DTimelineViewController *scene;
    GLKVector3 size;
}

//- (id)initWithScene:(ZN3DTimelineViewController *)aGameScene withEventItem:(EventItem*)theEventItem;
- (id)initWithEventItem:(EventItem*)theEventItem atLocationOrigin:(GLKVector3)theOrigin onScene:(ZN3DTimelineViewController*)theScene atSize:(GLKVector3)theSize;

- (void)updateWithDelta:(NSNumber*)aDelta;
- (void)render;
- (UIImage*)labelImage;

@end
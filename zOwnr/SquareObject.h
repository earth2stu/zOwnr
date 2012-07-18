//
//  SquareObject.h
//  zOwnr
//
//  Created by Stuart Watkins on 15/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNAbstractObject.h"
#import "ZN3DTimelineViewController.h"

@interface SquareObject : ZNAbstractObject {
    ZN3DTimelineViewController *sceneController;
}

- (id)initWithScene:(ZN3DTimelineViewController *)aGameScene withTexture:(NSString*)imageFile;

@end

//
//  zOwnrConstants.h
//  zOwnr
//
//  Created by Stuart Watkins on 14/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <GLKit/GLKit.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#ifndef zOwnr_zOwnrConstants_h
#define zOwnr_zOwnrConstants_h



#endif

typedef enum {
    kScreenModeBrowseEvents,
    kScreenModeSingleEvent
} kScreenMode;

typedef enum {
    kQuadrantEdgeTop,
    kQuadrantEdgeBottom,
    kQuadrantEdgeLeft,
    kQuadrantEdgeRight
} kQuadrantEdge;

typedef enum {
    kQuadrantCornerTopLeft,
    kQuadrantCornerTopRight,
    kQuadrantCornerBottomLeft,
    kQuadrantCornerBottomRight,
    kQuadrantCornerCentre
} kQuadrantCorner;



static const int kMainEdgeViewHeight = 45;

static const int kTLlocationHeight = 50;
static const int kTLlocationOffset = 70;
static const int kTLlocationSelectedHeight = 200;
static const int kTLtopMargin = 45;
static const int kTLleftMargin = 0;

static const kQuadrantCorner kQuadrantCornerDefault = kQuadrantCornerTopLeft;

static const int kEdgeViewOverlap = 50;

static NSString *kZNSessionIDKey = @"ZNSessionID";
static NSString *kZNCurrentUserIDKey = @"ZNCurrentUserID";
static NSString *kZNChangeSelectionKey = @"ZNChangeSelection";
static NSString *kZNLoadingSelectionKey = @"ZNLoadingSelection";
static NSString *kZNLoadedSelectionKey = @"ZNLoadedSelection";
static NSString *kZNChangeZoneKey = @"ZNChangeZone";

typedef struct {
    GLKVector3      vertex;
    GLKVector3      normal;
    GLKVector2      texCoord;
} ZNTexturedVertexData3D;

@protocol ZNSelectable <NSObject>

//

@end


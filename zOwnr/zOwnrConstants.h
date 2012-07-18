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

static const int kTLlocationHeight = 50;
static const int kTLlocationOffset = 70;
static const int kTLlocationSelectedHeight = 200;
static const int kTLtopMargin = 45;
static const int kTLleftMargin = 80;

typedef struct {
    GLKVector3      vertex;
    GLKVector3      normal;
    GLKVector2      texCoord;
} ZNTexturedVertexData3D;
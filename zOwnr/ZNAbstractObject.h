//
//  SSAbstractObject.h
//  GLKit_TD3D
//
// Copyright (c) 2011 71Squared
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

#import "ZNModel.h"
#import <GLKit/GLKit.h>
#import "ZNAssetManager.h"
#import "ZN3DTimelineViewController.h"

#define BIT(x) (1<<(x))

@class AssetManager;



@interface ZNAbstractObject : NSObject {
    
    ZNAssetManager            __weak *assetManager;          // Reference to the asset manager which holds the models
    
    
    GLKBaseEffect           __weak *shader;                // Reference to the shader we are going to be using
    ZNModel __strong        *model;                 // Model to be used when rendering

    GLKVector3              position;               // Position at which we will be rendering the object
    GLKVector3              direction;              // Normalised vector representing the direction of the object
    GLfloat                 speed;                  // Speed of the object
    GLKMatrix4              modelMatrix;            // Objects local model matrix
              
    
}

@property (nonatomic, weak) ZNAssetManager *assetManager;

@property (nonatomic, weak) GLKBaseEffect *shader;
@property (nonatomic) GLKVector3 position;
@property (nonatomic) GLKVector3 direction;
@property (nonatomic) GLfloat speed;
@property (nonatomic) GLKMatrix4 modelMatrix;
@property (nonatomic, strong) ZNModel *model;

// Designated initializer that takes a reference to the game scene that will own this object
- (id)initWithScene:(ZN3DTimelineViewController *)scene;

// Passes in the amount of time since the last update which can then be used
// to update the logic of this object e.g. it's position
- (void)updateWithDelta:(GLfloat)aDelta;

// Render this object based on it's current position
- (void)render;

@end

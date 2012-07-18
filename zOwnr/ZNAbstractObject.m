//
//  SSAbstractObject.m
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

#import "ZNAbstractObject.h"

#pragma mark - Private Interface

@interface ZNAbstractObject () 

@end

#pragma mark - Public Implementation

@implementation ZNAbstractObject

@synthesize assetManager;


@synthesize shader;
@synthesize position;
@synthesize direction;
@synthesize speed;
@synthesize modelMatrix;
@synthesize model;

- (id)initWithScene:(ZN3DTimelineViewController *)scene {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
    // Implemented in inheriting class
}

- (void)render {
    // Implemented in inheriting class
}

- (void)setPosition:(GLKVector3)aPosition
{
	position = aPosition;
    
}

@end

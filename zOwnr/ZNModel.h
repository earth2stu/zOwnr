//
//  SSModel.h
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

#import <GLKit/GLKit.h>

@interface ZNModel : NSObject{
    NSString *modelName;
    GLKTextureInfo *texture;
    GLuint vertexArrayName;
    GLuint vertexBufferName;
    GLuint vertexCount;
    GLfloat scale;
}

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) GLKTextureInfo *texture;
@property (nonatomic, assign) GLuint vertexArrayName;
@property (nonatomic, assign) GLuint vertexBufferName;
@property (nonatomic, assign) GLuint vertexCount;
@property (nonatomic, assign) GLfloat scale;

// Creates an model instance that contains the vertex, normal and texture coordinates along with the texture image for that model.
// It also creates a vertex array (vertexArrayName) that can be bound to before rendering which removes the need to continually 
// bind this models vertex buffer
- (id)initWithTexturedMeshVertexData:(const ZNTexturedVertexData3D[])aVertexData vertexCount:(GLuint)aVertexCount textureFileName:(NSString *)aTextureFileName scale:(GLfloat)aScale modelName:(NSString *)aName withImage:(UIImage*)image;

@end

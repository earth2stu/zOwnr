//
//  AssetManager.h
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
//  This class is responsible for creating the VBO's and Textures to be used in the game.
//
//  Each VBO and Texture created will be given a text key that can be used to request a specific VBO or
//  texture. This will allow us to create just a single version of a VBO or Texture that can be reused 
//  many times reducing the amount of memory being used.
//

#import <GLKit/GLKit.h>

@class ZNModel;

@interface ZNAssetManager : NSObject 

// Loads a textured mesh using data held in a header file. It also creates the texture associated with the mesh
- (void)loadTexturedMeshWithData:(const ZNTexturedVertexData3D[])aVertexData vertexCount:(GLuint)aVertexCount textureFileName:(NSString *)aTextureFileName scale:(GLfloat)aScale modelName:(NSString *)aModelName;

// Returns an SSModel using the model name provided
- (ZNModel *)getModelWithName:(NSString *)aModelName;

// Creates a texture using the image file provided. If that filename has already been used to create a texture then that texture name is returned
- (GLKTextureInfo*)createTextureWithFileName:(NSString*)aTextureFileName;

// Returns the texture name of the texture matching the texture name passed in
- (GLKTextureInfo*)getTextureWithFileName:(NSString*)aTextureName;

// Removes the texture with a matching filename from the textures cache
- (void)removeTextureWithFileName:(NSString*)aTextureFileName;

@end

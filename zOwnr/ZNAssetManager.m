//
//  AssetManager.m
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


#import "ZNAssetManager.h"
#import "ZNModel.h"

#pragma mark -
#pragma mark Private interface

@interface ZNAssetManager () {
    
    __strong NSMutableDictionary *models;    // Dictionary used to hold information about the 3D models the game uses
    __strong NSMutableDictionary *textures;  // Dictionary used to hold information about the textures that the game uses
    
}

@end

#pragma mark -
#pragma mark Public implementation

@implementation ZNAssetManager

- (id) init
{
    self = [super init];
    if (self != nil) {
        
        // Set up the mutable arrays that will hold the VBO and Texture names
        models = [[NSMutableDictionary alloc] init];
        textures = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)loadTexturedMeshWithData:(const ZNTexturedVertexData3D[])aVertexData vertexCount:(GLuint)aVertexCount textureFileName:(NSString *)aTextureFileName scale:(GLfloat)aScale modelName:(NSString *)aModelName {
    
    // Check to see if the name of this model has already been used
    if ([models objectForKey:aModelName]) {
        NSLog(@"WARNING: A model with called '%@' already exists", aModelName);
        return;
    }
    
    // Create a new instance of SSModel and add it to the models dictionary with its name as the key
    ZNModel *newModel = [[ZNModel alloc] initWithTexturedMeshVertexData:aVertexData vertexCount:aVertexCount textureFileName:aTextureFileName scale:aScale modelName:aModelName withImage:nil];
    [models setObject:newModel forKey:aModelName];
    
}

- (void)removeModelWithName:(NSString *)aModelName {
    [models removeObjectForKey:@"aModelName"];
}

- (ZNModel *)getModelWithName:(NSString *)aModelName {
    return [models objectForKey:aModelName];
}

- (GLKTextureInfo*)createTextureWithFileName:(NSString*)aTextureFileName {
    
    // Check to see if a texture with the same texture name has been created
    GLKTextureInfo *texture = (GLKTextureInfo*)[textures objectForKey:aTextureFileName];
    
    // If a texture name has been found then pass it back
    if (texture)
        return texture;
    
    // Sort out the filename for the texture and get it's path
    NSString *textureFileName = [aTextureFileName stringByDeletingPathExtension];
    NSString *textureFileNameExtension = [aTextureFileName pathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:textureFileName ofType:textureFileNameExtension];
    
    // If no path is passed back then something is wrong
    NSAssert1(path, @"Unable to find texture file: %@", aTextureFileName);
    
    // Build a dictionary that holds options for the texture. This is currently setting up the texture to use an origi that is in
    // the bottom left hand corner. This stops the texture being rendered upside down.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    
    // Load the texture
    NSError *outError;
    texture = [GLKTextureLoader textureWithContentsOfFile:path options:dict error:&outError];
    
    // Go bang if the texture loaded came across an error
    NSAssert1(!outError, @"Error loading texture: %@", [outError localizedDescription]);
    
    [textures setValue:texture forKey:aTextureFileName];
    
    return texture;
    
}

- (GLKTextureInfo*)getTextureWithFileName:(NSString*)aTextureFileName {
    
    // Check to see if a texture with the same texture name has been created
    GLKTextureInfo *texture = (GLKTextureInfo*)[textures objectForKey:aTextureFileName];
    
    if (texture)
        return texture;
    
    NSLog(@"No texture found with the name: %@", aTextureFileName);
    return nil;
    
}

- (void)removeTextureWithFileName:(NSString*)aTextureFileName {
    
    [textures removeObjectForKey:aTextureFileName];
    
}

@end

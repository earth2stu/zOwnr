//
//  SSModel.m
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

#pragma mark - Private Implementation

@interface ZNModel () {
@private
    
}


@end

#pragma mark - Implementation

@implementation ZNModel

@synthesize modelName;
@synthesize texture;
@synthesize vertexArrayName;
@synthesize vertexBufferName;
@synthesize vertexCount;
@synthesize scale;

- (void)dealloc {
    
    NSLog(@"Deallocating Model: %@", modelName);
    
    // Delete the VAO, VBO when this object is deallocated
    if (vertexArrayName)
        glDeleteVertexArraysOES(1, &vertexArrayName);
    
    if (vertexBufferName)
        glDeleteBuffers(1, &vertexBufferName);

    
}

- (id)initWithTexturedMeshVertexData:(const ZNTexturedVertexData3D[])aVertexData vertexCount:(GLuint)aVertexCount textureFileName:(NSString *)aTextureFileName scale:(GLfloat)aScale modelName:(NSString *)aName withImage:(UIImage*)image{
    
    self = [super init];
    if (self) {
        
        modelName = aName;
        scale = aScale;
        vertexCount = aVertexCount;
        
        // Create the vertex array that is going to store the details of this models VBO and it's bindings
        glGenVertexArraysOES(1, &vertexArrayName);
        glBindVertexArrayOES(vertexArrayName);
        
        // Generate the buffer array and bind the necessary 
        glGenBuffers(1, &vertexBufferName);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferName);
        glBufferData(GL_ARRAY_BUFFER, sizeof(ZNTexturedVertexData3D) * aVertexCount, aVertexData, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(ZNTexturedVertexData3D), BUFFER_OFFSET(0));
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(ZNTexturedVertexData3D), BUFFER_OFFSET(12));
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(ZNTexturedVertexData3D), BUFFER_OFFSET(24));
        glBindVertexArrayOES(0);
        
        
        // Build a dictionary that holds options for the texture. This is currently setting up the texture to use an origi that is in
        // the bottom left hand corner. This stops the texture being rendered upside down.
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
        
        // Load the texture
        NSError *outError;
        
        if (aTextureFileName) {
            // Sort out the filename for the texture and get it's path
            NSString *textureFileName = [aTextureFileName stringByDeletingPathExtension];
            NSString *textureFileNameExtension = [aTextureFileName pathExtension];
            NSString *path = [[NSBundle mainBundle] pathForResource:textureFileName ofType:textureFileNameExtension];
            
            // If no path is passed back then something is wrong
            NSAssert1(path, @"Unable to find texture file: %@", aTextureFileName);
            
            
            
            
            
            texture = [GLKTextureLoader textureWithContentsOfFile:path options:dict error:&outError];
            
            
            
            // Go bang if the texture loaded came across an error
            NSAssert1(!outError, @"Error loading texture: %@", [outError localizedDescription]);
        } else {
            
            texture = [GLKTextureLoader textureWithCGImage:[image CGImage] options:dict error:&outError];
            
            
            // Go bang if the texture loaded came across an error
            NSAssert1(!outError, @"Error loading texture: %@", [outError localizedDescription]);
        }
        
        
        // Generate a btConvexHullShape for the collision hull. This is being done using bullet which is only
        // suitable for small simple models, otherwise a collision hull shape should be defined externally in something like
        // blender and then loaded here as a mesh
        
        NSLog(@"Created model called: %@ with texture name: %i and vertex count: %i", modelName, texture.name, vertexCount);
    }
    return self;
}

@end

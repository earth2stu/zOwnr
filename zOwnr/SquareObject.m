//
//  SquareObject.m
//  zOwnr
//
//  Created by Stuart Watkins on 15/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "SquareObject.h"
#import "SquareModel.h"

@implementation SquareObject


- (id)initWithScene:(ZN3DTimelineViewController *)scene withTexture:(NSString*)imageFile {
    
    self = [super init];
    if (self) {
        
        // Hook up to the game controller that is responsible for this model
        
        sceneController = scene;
        assetManager = sceneController.assetManager;
        
        // Check to see if an enemy fighter model has already been loaded into the asset manager and
        // if so retrieve it for use in this object. If not found then get the asset manager to load it
        model = [assetManager getModelWithName:imageFile];
        if (!model) {
            [assetManager loadTexturedMeshWithData:SquareVertexData vertexCount:kSquareNumberOfVertices textureFileName:imageFile scale:10.0 modelName:imageFile];
            model = [assetManager getModelWithName:imageFile];
        }
        
        self.position = GLKVector3Make(0, 0, -100);
        

    }
    return self;
}


- (void)updateWithDelta:(GLfloat)aDelta {
    
    
    // Initialize the models local matrix
    modelMatrix = GLKMatrix4Identity;
    
    // Translate to the location of the model.The order of operations on the matrix is important, so the translation
    // should be done first
    
    
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
    
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, [AnimatedStillAnimal degreesToRadians:angle] * -1, 0.0f, 1.0f, 0.0f);
    
    
        
    // If the scale of this model is other than 1.0 then apply the scale to the matrix
    if (model.scale != 1.0) {
//        modelMatrix = GLKMatrix4Scale(modelMatrix, localScale, localScale, localScale);
    }
    
    
    //basis.setFromOpenGLSubMatrix(modelMatrix.m);
}

- (void)render {
    
    // Mark the OGL commands
    glPushGroupMarkerEXT(0, "Ground");
    {    
        
        /*
         
         shader.texture2d0.envMode = GLKTextureEnvModeReplace;
         shader.texture2d0.target = GLKTextureTarget2D;
         if (self.spriteAnimation != nil) {
         shader.texture2d0.name = [self.spriteAnimation currentFrame].name;
         gameSceneController.currentBoundTexture = [self.spriteAnimation currentFrame].name;
         } else {
         shader.texture2d0.name = model.texture.name;
         gameSceneController.currentBoundTexture = model.texture.name;
         }
         
         */
        // Set the current effect to use this models texture
        if (sceneController.currentBoundTexture != model.texture.name) {
            sceneController.currentBoundTexture = model.texture.name;
            shader.texture2d0.name = model.texture.name;
        }
        
        // Update the shaders model matrix with the matrix for this model making sure to multiply the scenes model
        // matrix so that the model is position correctly with the world based on the gyro info from the device
        shader.transform.modelviewMatrix = GLKMatrix4Multiply(sceneController.sceneModelMatrix, modelMatrix);
        
        // Prepare the effect
        [shader prepareToDraw];
        
        // Bind to the vertex object array for this model
        glBindVertexArrayOES(model.vertexArrayName);
        
        // Draw the model
        glDrawArrays(GL_TRIANGLE_FAN, 0, model.vertexCount);
        
        glBindVertexArrayOES(0);
    }
    glPopGroupMarkerEXT();
    
}



@end

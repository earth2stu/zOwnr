//
//  ZN3DEventItemObject.m
//  zOwnr
//
//  Created by Stuart Watkins on 16/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZN3DEventItemObject.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZN3DEventItemObject

- (id)initWithEventItem:(EventItem*)theEventItem atLocationOrigin:(GLKVector3)theOrigin onScene:(ZN3DTimelineViewController*)theScene atSize:(GLKVector3)theSize {
    
    self = [super init];
    if (self)
    {
        scene = theScene;
        origin = theOrigin;
        eventItem = theEventItem;
        size = theSize;
        self.shader = scene.effect;
        
        /*
        NSString *imageFile = @"icon2_114.png";
        // Check to see if an enemy fighter model has already been loaded into the asset manager and
        // if so retrieve it for use in this object. If not found then get the asset manager to load it
        model = [scene.assetManager getModelWithName:[NSString stringWithFormat:@"%@-%i", imageFile, [eventItem.eventItemID intValue]]];
        if (!model) {
            [scene.assetManager loadTexturedMeshWithData:SquareVertexData vertexCount:kEventItemNumberOfVertices textureFileName:imageFile scale:10.0 modelName:[NSString stringWithFormat:@"%@-%i", imageFile, [eventItem.eventItemID intValue]]];
            model = [scene.assetManager getModelWithName:[NSString stringWithFormat:@"%@-%i", imageFile, [eventItem.eventItemID intValue]]];
        }
        */
        
        
        model = [[ZNModel alloc] initWithTexturedMeshVertexData:EventItemVertexData vertexCount:kEventItemNumberOfVertices textureFileName:nil scale:10.0 modelName:eventItem.name withImage:[self labelImage]];
        
        self.position = origin;
//self.position = GLKVector3Make(50, 0, -100);
        
    }
    return self;
    
    
}


- (UIImage*)labelImage {
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    myLabel.text = eventItem.name;
    myLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    myLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];   
    myLabel.backgroundColor = [UIColor whiteColor];
    myLabel.textAlignment = UITextAlignmentCenter;
    
    UIGraphicsBeginImageContext(myLabel.bounds.size);
    
    //CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, 30);
    
    //CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    
    [myLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return layerImage;
}





- (void)updateWithDelta:(NSNumber*)aDelta {
    GLfloat delta = [aDelta floatValue];
    
    // Initialize the models local matrix
    modelMatrix = GLKMatrix4Identity;
    
    // Translate to the location of the model.The order of operations on the matrix is important, so the translation
    // should be done first
    
    
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
    
    //    modelMatrix = GLKMatrix4Rotate(modelMatrix, [AnimatedStillAnimal degreesToRadians:angle] * -1, 0.0f, 1.0f, 0.0f);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, 0, 1, 0, 0);
    
    
    // If the scale of this model is other than 1.0 then apply the scale to the matrix
    if (model.scale != 1.0) {
        //modelMatrix = GLKMatrix4Scale(modelMatrix, size.x, 1, size.z);
    }

    
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
        if (scene.currentBoundTexture != model.texture.name) {
            scene.currentBoundTexture = model.texture.name;
            shader.texture2d0.name = model.texture.name;
        }
        
        // Update the shaders model matrix with the matrix for this model making sure to multiply the scenes model
        // matrix so that the model is position correctly with the world based on the gyro info from the device
        shader.transform.modelviewMatrix = GLKMatrix4Multiply(scene.sceneModelMatrix, modelMatrix);
        
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

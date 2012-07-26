//
//  EventAnnotationView.m
//  zOwnr
//
//  Created by Stuart Watkins on 19/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventAnnotationView.h"

@implementation EventAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        NSString *imageName = @"";
        
        if ([reuseIdentifier isEqualToString:@"location"]) {
            imageName = @"audio.png";
        } else {
            imageName = @"photo.png";
        }
        
                
                        
        UIImageView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [pinView setFrame:CGRectMake(-16, -37, 32, 37)];
        [self addSubview:pinView];
        
    }
    return self;
    
}

@end

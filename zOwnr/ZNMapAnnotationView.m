//
//  ZNMapAnnotationView.m
//  zOwnr
//
//  Created by Stuart Watkins on 24/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMapAnnotationView.h"



@implementation ZNMapAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation, ZNMapPinView>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        NSString *imageName = [annotation imageName];
        UIImage *image = [UIImage imageNamed:imageName];
        
        
        
        UIImageView *pinView = [[UIImageView alloc] initWithImage:image];
        [pinView setFrame:CGRectMake(-(image.size.width / 2.0), -(image.size.height / 2.0), image.size.width, image.size.height)];
        [self addSubview:pinView];
        
    }
    return self;
    
}



@end

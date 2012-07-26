//
//  ZNMapOverlayView.m
//  zOwnr
//
//  Created by Stuart Watkins on 26/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMapOverlayView.h"
#import "ZNMapAnnotationView.h"

@implementation ZNMapOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOverlay:(id <MKOverlay, ZNMapPinView>)overlay
{
    if (self = [super initWithOverlay:overlay]) {
        NSString *imageName = [overlay imageName];
        overlayImage = [UIImage imageNamed:imageName];
    }
    return self;
}



- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    
    CGRect drawRect = [self rectForMapRect:mapRect];
    
    CGContextDrawImage(ctx, drawRect, overlayImage.CGImage);
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

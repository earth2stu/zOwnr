//
//  ZNMapAnnotationView.h
//  zOwnr
//
//  Created by Stuart Watkins on 24/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol ZNMapPinView <NSObject>

- (NSString*)imageName;

@end

@interface ZNMapAnnotationView : MKAnnotationView

@end

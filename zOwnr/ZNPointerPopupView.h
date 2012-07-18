//
//  ZNPointerPopup.h
//  zOwnr
//
//  Created by Stuart Watkins on 26/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNPointerPopupView : UIView

@property (nonatomic) float value;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) NSString *text;

- (void)setNewText:(NSString*)newText;

@end

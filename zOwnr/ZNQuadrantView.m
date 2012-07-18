//
//  ZNQuadrantView.m
//  zOwnr
//
//  Created by Stuart Watkins on 18/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNQuadrantView.h"

@interface ZNQuadrantView()

- (kQuadrantCorner)cornerFromLocation:(CGPoint)location;

@end

@implementation ZNQuadrantView

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zOwnr_large_transp_icon.png"]];
        [logoImage setFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:logoImage];
        
        self.backgroundColor = [UIColor clearColor];
        
        currentCorner = kQuadrantCornerBottomRight;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    startPoint = location;
    currentCorner = [self cornerFromLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    // work out which direction we are going .. +-x or +-y
    
    CGPoint viewLocation;
    
    float xDiff = location.x - startPoint.x;
    float yDiff = location.y - startPoint.y;
    
    if (fabsf(xDiff) >= fabsf(yDiff)) {
        // we are moving left-to-right
        viewLocation.x = location.x;
        
        if (currentCorner == kQuadrantCornerTopLeft || currentCorner == kQuadrantCornerTopRight) {
            currentEdge = kQuadrantEdgeTop;
            viewLocation.y = 0;
        } else {
            currentEdge = kQuadrantEdgeBottom;
            viewLocation.y = 320;
        }
        [self.delegate didMoveToPoint:location.x onEdge:currentEdge];
        
    } else {
        viewLocation.y = location.y;
        if (currentCorner == kQuadrantCornerTopLeft || currentCorner == kQuadrantCornerBottomLeft) {
            currentEdge = kQuadrantEdgeLeft;
            viewLocation.x = 0;
        } else {
            currentEdge = kQuadrantEdgeRight;
            viewLocation.x = 480;
        }
        [self.delegate didMoveToPoint:location.y onEdge:currentEdge];
        
    }
    
    
    [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
    
    [self setCenter:viewLocation];
    
    //self.frame = CGRectMake(viewLocation.x, location.y, 
    //                        self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    kQuadrantCorner finalCorner = [self cornerFromLocation:location];
    
    [self.delegate didSwitchToCorner:finalCorner];
    
    [UIView beginAnimations:@"FinalDest" context:nil];
    
    switch (finalCorner) {
        case kQuadrantCornerTopLeft:
            [self setCenter:CGPointMake(0, 0)];
            break;
            
        case kQuadrantCornerTopRight:
            [self setCenter:CGPointMake(480, 0)];
            break;
            
        case kQuadrantCornerBottomRight:
            [self setCenter:CGPointMake(480, 320)];
            break;
            
        case kQuadrantCornerBottomLeft:
            [self setCenter:CGPointMake(0, 320)];
            break;
            
        default:
            break;
    }
    
    [UIView commitAnimations];
    
    
    
}

- (kQuadrantCorner)cornerFromLocation:(CGPoint)location {
    if (location.x >= 240 && location.y >= 160) {
        return kQuadrantCornerBottomRight;
    } else if (location.x < 240 && location.y >= 160) {
        return kQuadrantCornerBottomLeft;
    } else if (location.x < 240 && location.y < 160) {
        return kQuadrantCornerTopLeft;
    } else if (location.x >= 240 && location.y < 160) {
        return kQuadrantCornerTopRight;
    }
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

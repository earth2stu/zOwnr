//
//  ZNQuadrantView.m
//  zOwnr
//
//  Created by Stuart Watkins on 18/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNLogoView.h"

@interface ZNLogoView()

- (kQuadrantCorner)cornerFromLocation:(CGPoint)location;
- (void)enterMenu;

@end

@implementation ZNLogoView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zOwnr_large_transp_icon.png"]];
        [logoImage setFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:logoImage];
        
        UIImageView *mapImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"07-map-marker.png"]];
        [mapImage setFrame:CGRectMake(25, 25, 16, 26)];
        [self addSubview:mapImage];
        
        UIImageView *timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"11-clock.png"]];
        [timeImage setFrame:CGRectMake(25, 50, 25, 25)];
        [self addSubview:timeImage];
        
        UIImageView *socialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"112-group.png"]];
        [socialImage setFrame:CGRectMake(50, 25, 32, 21)];
        [self addSubview:socialImage];
        
        UIImageView *mediaImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"09-chat-2.png"]];
        [mediaImage setFrame:CGRectMake(50, 50, 24, 22)];
        [self addSubview:mediaImage];

        
        [self setFrame:CGRectMake(0, 0, 100, 100)];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zOwnr_large_transp_icon.png"]];
        [logoImage setFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:logoImage];
        
                
        
        
        //[self setFrame:CGRectMake(0, 0, 100, 100)];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setCurrentCorner:(kQuadrantCorner)corner {
    currentCorner = corner;
    
    
    [UIView beginAnimations:@"FinalDest" context:nil];
    
    switch (currentCorner) {
        case kQuadrantCornerTopLeft:
            [self setCenter:CGPointMake(0, 0)];
            break;
            
        case kQuadrantCornerTopRight:
            [self setCenter:CGPointMake(self.superview.bounds.size.width, 0)];
            break;
            
        case kQuadrantCornerBottomRight:
            [self setCenter:CGPointMake(self.superview.bounds.size.width, self.superview.bounds.size.height)];
            break;
            
        case kQuadrantCornerBottomLeft:
            [self setCenter:CGPointMake(0, self.superview.bounds.size.height)];
            break;
            
        case kQuadrantCornerCentre:
            [self setCenter:CGPointMake(240, 160)];
            break;
            
        default:
            break;
    }

    [UIView commitAnimations];

    
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
            viewLocation.y = self.superview.bounds.size.height;
        }
        [self.delegate didMoveToPoint:location.x onEdge:currentEdge];
        
    } else {
        viewLocation.y = location.y;
        if (currentCorner == kQuadrantCornerTopLeft || currentCorner == kQuadrantCornerBottomLeft) {
            currentEdge = kQuadrantEdgeLeft;
            viewLocation.x = 0;
        } else {
            currentEdge = kQuadrantEdgeRight;
            viewLocation.x = self.superview.bounds.size.width;
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
    
    if (fabsf(location.x - startPoint.x) < 5 && fabsf(location.y - startPoint.y) < 5 ) {
        // was a tap (or close enuf)
        //[self enterMenu];
        [self.delegate didToggleMenuForCorner:currentCorner];
        
    } else {
    
        [self.delegate didCloseMenu];
        
        // was a drag!
        kQuadrantCorner finalCorner = [self cornerFromLocation:location];
        
        //[self.delegate didSwitchToCorner:finalCorner];
        
        
        if (finalCorner != currentCorner) {
            [self.delegate didSwitchToCorner:finalCorner];
        } else {
            [self setCurrentCorner:currentCorner];
        }
        
    }
}


- (void)enterMenu {
/*    
    ZNQuadrantMenuView *topLeft = [[ZNQuadrantMenuView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [self addSubview:topLeft];
    
    [UIView beginAnimations:@"gotoMenu" context:nil];
    
    [self setCenter:CGPointMake(240, 160)];
    
    [topLeft setFrame:CGRectMake(0,0,240,160)];
    
    [UIView commitAnimations];
    
  */  
    
}

- (kQuadrantCorner)cornerFromLocation:(CGPoint)location {
    if (location.x >= (self.superview.bounds.size.width / 2) && location.y >= (self.superview.bounds.size.height / 2)) {
        return kQuadrantCornerBottomRight;
    } else if (location.x < (self.superview.bounds.size.width / 2) && location.y >= (self.superview.bounds.size.height / 2)) {
        return kQuadrantCornerBottomLeft;
    } else if (location.x < (self.superview.bounds.size.width / 2) && location.y < (self.superview.bounds.size.height / 2)) {
        return kQuadrantCornerTopLeft;
    } else if (location.x >= (self.superview.bounds.size.width / 2) && location.y < (self.superview.bounds.size.height / 2)) {
        return kQuadrantCornerTopRight;
    }
    return -1;
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

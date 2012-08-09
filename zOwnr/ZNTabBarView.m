//
//  ZNTabBar.m
//  zOwnr
//
//  Created by Stuart Watkins on 26/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNTabBarView.h"

@implementation ZNTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        tabViews = [self defaultTabContentViews];
        
    }
    return self;
}


#pragma mark Tab Bar Setup



- (void)addTabNamed:(NSString*)tabName withView:(ZNTabContentView*)tabContentView {
    [tabViews setObject:tabContentView forKey:tabName];
    [self redrawTabs];
}

- (void)setCurrentTabByName:(NSString*)tabName {
    
    
    if (currentView) {
        [currentView removeFromSuperview];
        currentView = nil;
    }
    
    currentView = [tabViews objectForKey:tabName];
    [currentView setFrame:[self currentContentFrame]];
    [self addSubview:currentView];
    
    /*
    Class c = [tabClasses objectForKey:tabName];
    
    if ([c isSubclassOfClass:[ZNTabContentView class]]) {
        
        
        
        currentView = [((ZNTabContentView*)[c alloc]) initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:currentView];
        
    }
    */
}

- (CGRect)currentContentFrame {
    return CGRectMake(0, kMainEdgeViewHeight, self.frame.size.width, self.frame.size.height - kMainEdgeViewHeight);
}

#pragma mark 

- (void)redrawTabs {
    
}

- (void)setFinalFrame:(CGRect)frame {
    
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

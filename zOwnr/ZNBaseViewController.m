//
//  ZNBaseViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNBaseViewController.h"


@interface ZNBaseViewController() {
    
    
}

- (kQuadrantCorner)cornerToQuadrant:(kQuadrantCorner)corner;
- (void)openMenuFor:(id<ZNMenuView>)sender;

@end

@implementation ZNBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ZNSettings shared] setDelegate:self];
    
    [self.view setAutoresizesSubviews:NO];
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
    
    mainView = [[ZNMainView alloc] initWithFrame:CGRectMake(0, 0, 480, 320) withDelegate:self];
    [self.view addSubview:mainView];
    
    
    menuView = [[ZNMenuView alloc] initWithFrame:CGRectMake(0, 0, 480, 320) andDelegate:self];
    [self.view addSubview:menuView];
    isMenuOpen = NO;
    
    titleView = [[ZNTitleView alloc] initWithFrame:CGRectMake(0, 0, 480, 50)];
    [self.view addSubview:titleView];
    
    logoView = [[ZNLogoView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    logoView.delegate = self;
    [self.view addSubview:logoView];
    
    
    [self setCurrentQuadrant:kQuadrantCornerDefault];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        //[self.view setFrame:CGRectMake(0, 0, 480, 320)];
        [mainView setFrame:CGRectMake(0, 0, 480, 320)];
        [menuView setFrame:CGRectMake(0, 0, 480, 320)];
    } else {
        //[self.view setFrame:CGRectMake(0, 0, 320, 480)];
        [mainView setFrame:CGRectMake(0, 0, 320, 480)];
        [menuView setFrame:CGRectMake(0, 0, 320, 480)];
        //[logoView setCurrentCorner:[self cornerToQuadrant:currentQuadrant]];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [logoView setCurrentCorner:[self cornerToQuadrant:currentQuadrant]];
    
   // NSLog(@"%@", [NSString stringWithFormat:@"Rotation: %s [w=%f, h=%f]",  
   //               UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? "Portrait" : "Landscape",
   //               size.width, size.height]);
}

#pragma mark High Level Settings

- (void)setCurrentScreenMode:(kScreenMode)mode {
    currentScreenMode = mode;
    
    
    
}

- (void)setCurrentQuadrant:(kQuadrantCorner)quadrant {
    currentQuadrant = quadrant;
    
    [mainView setCurrentQuadrant:quadrant];
    [logoView setCurrentCorner:[self cornerToQuadrant:currentQuadrant]];
}

#pragma mark LogoViewDelegate

- (void)didSwitchToCorner:(kQuadrantCorner)corner {
    kQuadrantCorner q = [self cornerToQuadrant:corner];
    if (q != currentQuadrant) {
        [self setCurrentQuadrant:q];
    }
}

- (kQuadrantCorner)cornerToQuadrant:(kQuadrantCorner)corner {
    switch (corner) {
        case kQuadrantCornerBottomLeft:
            return kQuadrantCornerTopRight;
            break;
        case kQuadrantCornerTopRight:
            return kQuadrantCornerBottomLeft;
            break;
        case kQuadrantCornerTopLeft:
            return kQuadrantCornerBottomRight;
            break;
        case kQuadrantCornerBottomRight:
            return kQuadrantCornerTopLeft;
            break;
            
        default:
            return kQuadrantCornerDefault;
            break;
    }
}

- (CGPoint)cornerToPoint:(kQuadrantCorner)corner {
    switch (corner) {
        case kQuadrantCornerBottomLeft:
            return CGPointMake(kMainEdgeViewHeight, mainView.frame.size.height - kMainEdgeViewHeight);
            break;
            
        case kQuadrantCornerTopLeft:
            return CGPointMake(kMainEdgeViewHeight, kMainEdgeViewHeight);
            break;
            
        case kQuadrantCornerBottomRight:
            return CGPointMake(mainView.frame.size.width - kMainEdgeViewHeight, mainView.frame.size.height - kMainEdgeViewHeight);
            break;
            
        case kQuadrantCornerTopRight:
            return CGPointMake(mainView.frame.size.width - kMainEdgeViewHeight, kMainEdgeViewHeight);
            break;
            
        default:
            return CGPointMake(kMainEdgeViewHeight, kMainEdgeViewHeight);
            break;
    }
}

- (void)didMoveToPoint:(float)point onEdge:(kQuadrantEdge)edge {
    // used if we are going to animate while dragging the logo
    return;
}

- (void)openMenuForCorner:(kQuadrantCorner)corner {
    kQuadrantCorner quad = [self cornerToQuadrant:corner];
    switch (quad) {
        case kQuadrantCornerBottomLeft:
            // timeline
            //[self openMenuFor:cu
            break;
            
        default:
            break;
    }
}
             
#pragma mark MainViewDelegate
             
- (void)setCurrentMainView:(id<ZNMenuView>)mainSubView {
    currentMainView = mainSubView;
}

- (void)openMenuFor:(id<ZNMenuView>)sender {
    [menuView openMenu:sender fromPoint:CGPointMake(100, 100)];
}

- (void)closeMenu {
    
}

#pragma mark LogoViewDelegate

- (void)didToggleMenuForCorner:(kQuadrantCorner)corner {
    
    if (menuView.isHidden) {
        //isMenuOpen = YES;
        [menuView openMenu:currentMainView fromPoint:[self cornerToPoint:corner]];
    } else {
        [menuView closeMenu];
    }
    
}

- (void)didCloseMenu {
    [menuView closeMenu];
}

#pragma mark SettingsDelegate



- (void)setCurrentSelection:(id<ZNSelectable>)currentSelection {
    NSLog(@"just selected %@", currentSelection);
}

#pragma mark MenuViewDelegate

- (ZNSocialView*)socialView {
    return mainView.socialView;
}

- (ZNMediaView*)mediaView {
    return mainView.mediaView;
}

- (ZNMapView*)mapView {
    return mainView.mapView;
}

- (ZNTimelineScrollView*)timelineView {
    return mainView.timelineView;
}

- (void)switchToMainView:(id<ZNMenuView>)switchMainView {
    [self setCurrentMainView:switchMainView];
    if ([switchMainView isEqual:mainView.mapView]) {
        [self setCurrentQuadrant:kQuadrantCornerTopLeft];
    } else if ([switchMainView isEqual:mainView.timelineView]) {
        [self setCurrentQuadrant:kQuadrantCornerBottomLeft];
    } else if ([switchMainView isEqual:mainView.socialView]) {
        [self setCurrentQuadrant:kQuadrantCornerTopRight];
    } else if ([switchMainView isEqual:mainView.mediaView]) {
        [self setCurrentQuadrant:kQuadrantCornerBottomRight];
    }
    
}

@end

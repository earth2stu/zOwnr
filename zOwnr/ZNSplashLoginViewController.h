//
//  ZNSplashLoginViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 12/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "ZNFacebookLoginViewController.h"
#import "ZNPointerPopupView.h"
#import "FBConnect.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "ZNSplashLoading.h"

@interface ZNSplashLoginViewController : UIViewController <FBSessionDelegate, MKMapViewDelegate, RKObjectLoaderDelegate>{
//    ZNFacebookLoginViewController *fbLogin;
    Facebook *facebook;
    ZNSplashLoading *splashLoading;
    MKMapView *mapView;
    ZNPointerPopupView *zownrPopup;
    
}

//@property (nonatomic, retain) ZNFacebookLoginViewController *fbLogin;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

-(IBAction)facebookLogin:(id)sender;
-(IBAction)showInfoPage:(id)sender;

@end

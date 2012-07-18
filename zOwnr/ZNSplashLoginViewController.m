//
//  ZNSplashLoginViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 12/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNSplashLoginViewController.h"
#import "ZNAppDelegate.h"
#import "Event.h"

@implementation ZNSplashLoginViewController

//@synthesize fbLogin;
@synthesize facebook;
@synthesize mapView;

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

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mapView.delegate = self;
    
    [self.mapView.userLocation addObserver:self 
                                forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];
    
    
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)facebookLogin:(id)sender {
    //fbLogin = [[ZNFacebookLoginViewController alloc] initWithNibName:@"ZNFacebookLoginViewController" bundle:[NSBundle mainBundle]];
    //[self.navigationController pushViewController:fbLogin animated:YES];
    
    facebook = [[Facebook alloc] initWithAppId:@"232014290188966" andDelegate:self];
    
    
    NSArray* permissions =  [NSArray arrayWithObjects:
                             @"email", @"read_stream", @"publish_stream", @"offline_access", nil];
    
    [facebook authorize:permissions];
    
    //ZNAppDelegate *a = (ZNAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[a fromLoginToMain];
    
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    
    ZNAppDelegate *z = (ZNAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    splashLoading = [[ZNSplashLoading alloc] initWithNibName:@"ZNSplashLoading" bundle:nil];
    
    //[self setNextNotification];
    
    
    
    // valid facebook thingy so do the waiting view while we connect to api.zownr.com
    [z.window addSubview:splashLoading.view];
    [self.view removeFromSuperview];
    //[self.window addSubview:tabBarController.view];
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    [zownrPopup setNewText:@"not connected!"];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([[objects objectAtIndex:0] isKindOfClass:[Event class]]) {
        Event *e = (Event*)[objects objectAtIndex:0];
        //zownrPopup.text = e.name;
        [zownrPopup setNewText:e.name];
    }
}


// Listen to change in the userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{       
    if ([keyPath isEqualToString:@"location"]) {
        
    
    if (!zownrPopup)
    {
        zownrPopup = [[ZNPointerPopupView alloc] initWithFrame:CGRectMake(50.0f, 100.0f, 150.0f, 70.0f)];
        zownrPopup.backgroundColor = [UIColor clearColor];
        [zownrPopup setText:@"Locating..."];
        [self.view addSubview:zownrPopup];
        
        NSString *pathString = [NSString stringWithFormat:@"/public/currentevent?latitude=%4.8f&longitude=%4.8f", self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude];
        
        
        
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pathString delegate:self];
        
        
    }
    
        //if (!isRegionZoomed) {
            MKCoordinateRegion region;
            region.center = self.mapView.userLocation.coordinate;  
            
            MKCoordinateSpan span; 
            span.latitudeDelta  = 0.001; // Change these values to change the zoom
            span.longitudeDelta = 0.001; 
            region.span = span;
            
            [self.mapView setRegion:region animated:YES];
        //    isRegionZoomed = YES;
        //}
        
        //[self updateLocationToServer:self.mapview.userLocation.coordinate updateType:@"map"];
        //        z.coordinate = self.mapview.userLocation.coordinate;
        
        
        //       if (!self.mapview.userLocation.isUpdating) {
        //    [self.mapview.userLocation removeObserver:self forKeyPath:@"location"];
        
        //        PersonAnnotation *bridgeAnnotation = [[PersonAnnotation alloc] initWithCoordinate:self.mapview.userLocation.coordinate];
        
        //            [self.mapview addAnnotation:bridgeAnnotation];
        
        //       }
        
    }
    
    
}

-(IBAction)showInfoPage:(id)sender {
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    if (!infoViewController) {
//        infoViewController = [[ZNInfoViewController alloc] initWithNibName:@"ZNInfoViewController" bundle:nil];
//        infoViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    }
//    [self presentModalViewController:infoViewController animated:YES];
    
}

@end

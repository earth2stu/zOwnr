//
//  SplashLoading.m
//  zownr
//
//  Created by Stuart Watkins on 8/09/11.
//  Copyright 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNSplashLoading.h"
#import "ZNAppDelegate.h"
#import "User.h"
#import "NotificationViewController.h"
#import "FBLogin.h"
#import "Session.h"

//#import "ZNAgendaTableViewController.h"

@implementation ZNSplashLoading

@synthesize tabBarController;
@synthesize connectingView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self loadContact];
    tabBarController.delegate = self;
    //NSArray *keys = [NSArray arrayWithObjects:@"accessToken", @"latitude", @"longitude", nil];
    //NSArray *vals = [NSArray arrayWithObjects:[facebook accessToken], @"-33.000000", @"140.000000", nil];
    //NSDictionary* params = [NSDictionary dictionaryWithObjects:vals forKeys:keys];  
    ////NSDictionary* params = [NSDictionary dictionaryWithObject:z.facebook.accessToken forKey:@"accessToken"];
    //NSDictionary *params = [NSDictionary dictionaryWithObjects:<#(NSArray *)#> forKeys:<#(NSArray *)#>
    ////[[RKClient sharedClient] post:@"/user/fblogin" params:params delegate:self];  
    
    // try to login to zOwnr with the FB Access key
    
    FBLogin *f = [[FBLogin alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    f.accessToken = [defaults stringForKey:@"FBAccessTokenKey"];
    //[[RKObjectManager sharedManager] postObject:f delegate:self];
    [[RKObjectManager sharedManager] postObject:f mapResponseWith:nil delegate:self];

}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //[loading close];
    
    NSString *sessionID;
    
    
    // get the session key from the loaded objects
    for (id o in objects) {
        if ([o isKindOfClass:[Session class]]) {
            Session *s = (Session*)o;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            sessionID = s.sessionID;
            [defaults setValue:s.sessionID forKey:@"ZNSessionID"];
            [defaults synchronize];
        }
    }
    
    // add session key to http headers
    [[[RKObjectManager sharedManager] client] setValue:sessionID forHTTPHeaderField:@"Auth"]; 
    
    [self showTabBar];
    
    return;
}

-(void)resetToConnectingView {
    [[self.view.superview.subviews objectAtIndex:0] removeFromSuperview];
    
}

-(void)showTabBar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [defaults stringForKey:@"ZNSessionID"];
    if (sessionID == nil) {
        // unable to use the 
    }
    
    
    
    UIView *currentView = self.view;
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [currentView superview];
	
	// remove the current view and replace with myView1
	[currentView removeFromSuperview];
    
    
    
	[theWindow addSubview:tabBarController.view];
    //[theWindow insertSubview:tabBarController.view atIndex:0];
    
    
}



- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    
    [self showTabBar];
    
    //[[NotificationViewController alloc] initWithTitle:@"Unable to connect"];
    
    
    NSLog(@"Encountered an error: %@", error);
    /*
    zownrAppDelegate *z = (zownrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [z.window addSubview:z.loginController.view];
    [self.view removeFromSuperview];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
                           forView:z.window cache:YES];
    
        [self.view removeFromSuperview];
        [z.window addSubview:z.loginController.view];
    
    
    [UIView commitAnimations];
    
    */
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    /*
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)viewController;
        
        if ([nav.viewControllers count] > 0) {
            UIViewController *sub = [nav.viewControllers objectAtIndex:0];
            
            if ([sub isKindOfClass:[ZNAgendaTableViewController class]]) {
                ZNAgendaTableViewController *agenda = (ZNAgendaTableViewController*)sub;
                [agenda buildAgenda];
            }
            
            
        }
        
    }
    */
    
    
}


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {  
        // Handling GET /foo.xml  
        
        if ([response isOK]) {  
            // Success! Let's take a look at the data  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        
    } else if ([request isPOST]) {  
        
        // Handling POST /other.json  
        if ([response isJSON]) {  
            NSLog(@"Got a JSON response back from our POST!");  
        }  
        
    } else if ([request isDELETE]) {  
        
        // Handling DELETE /missing_resource.txt  
        if ([response isNotFound]) {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
    }  
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

-(IBAction)didCancelLogin:(id)sender {
    [[NotificationViewController alloc] initWithTitle:@"Cancelled login"];
}

@end

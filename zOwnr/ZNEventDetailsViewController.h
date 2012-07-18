//
//  ZNEventDetailsViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 29/05/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ZNDateTimeViewController.h"
#import "Event.h"

@interface ZNEventDetailsViewController : UITableViewController <MKMapViewDelegate, ZNDateTimeDelegate> {
    NSArray *photoGroup;
    IBOutlet UITableViewCell *startCell;
    IBOutlet UITableViewCell *finishCell;
    
    IBOutlet MKMapView *mapView;
    
    id currentSender;
    
    Event *event;
}

@property (nonatomic, retain) NSArray *photoGroup;

@end

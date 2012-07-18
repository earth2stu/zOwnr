//
//  ZNEventSuggestionTableViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 29/05/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZNTableLoadingViewController.h"

@interface ZNEventSuggestionTableViewController : UITableViewController <ZNLoadingViewDelegate>  {
    NSMutableArray *photosWithInfo;
    NSArray *chronoPhotos;
    NSMutableArray *photoGroups;
    ZNTableLoadingViewController *loadingView;
    
}

@end

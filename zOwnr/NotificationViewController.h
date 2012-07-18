//
//  NotificationViewController.h
//  zownr
//
//  Created by Stuart Watkins on 15/09/11.
//  Copyright 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController {
    NSString *title;
    IBOutlet UILabel *label;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) IBOutlet UILabel *label;

- (id)initWithTitle:(NSString*)titleString;
-(void) showAnimated;


@end

//
//  ZNDateTimeViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 30/05/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNDateTimeViewController;

@protocol ZNDateTimeDelegate <NSObject>

- (void)dateTimeViewController:(ZNDateTimeViewController*)dateTimeViewController didSetDate:(NSDate*)dateSet;

@end

@interface ZNDateTimeViewController : UIViewController {
    IBOutlet UIDatePicker *datePicker;

}

@property (nonatomic, weak) id <ZNDateTimeDelegate> delegate;
@property (nonatomic, retain) NSDate *theDate;

- (IBAction)didSaveDate:(id)sender;

@end

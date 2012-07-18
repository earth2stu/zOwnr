//
//  ZNTableLoadingViewController.h
//  zOwnr
//
//  Created by Stuart Watkins on 10/10/11.
//  Copyright (c) 2011 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZNLoadingViewDelegate <NSObject>

@optional

- (void)cancel;

@end

@interface ZNTableLoadingViewController : UIViewController {
    id<ZNLoadingViewDelegate> _delegate;
    IBOutlet UILabel *label;
    NSString *labelText;
}

//@property (nonatomic, retain) id delegate;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) NSString *labelText;

-(IBAction)cancelWaiting;
- (id)initWithDelegate:(id<ZNLoadingViewDelegate>)delegate andMessage:(NSString*)message;
-(void)close;
@end

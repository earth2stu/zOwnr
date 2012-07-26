//
//  ZNSocialLoginView.m
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNSocialLoginView.h"

@implementation ZNSocialLoginView

- (id)initWithFrame:(CGRect)frame withDelegate:(id<ZNSocialLoginDelegate>)del
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        delegate = del;
        loginTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        loginTableView.delegate = self;
        loginTableView.dataSource = self;
        [self addSubview:loginTableView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark TableViewDataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
    
    cell.textLabel.text = @"Facebook";
    
    [cell.imageView setImage:[UIImage imageNamed:@"facebook_bw.png"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [delegate facebookLogin];
    
}

@end

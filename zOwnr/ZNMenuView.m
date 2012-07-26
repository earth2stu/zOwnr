//
//  ZNMenuView.m
//  zOwnr
//
//  Created by Stuart Watkins on 23/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNMenuView.h"
#import "ZNMenuItem.h"
#import "ZNSocialView.h"
#import "ZNBaseViewController.h"
#import "ZNMapView.h"
#import "ZNMediaView.h"
#import "ZNTimelineScrollView.h"

@class ZNSettings;

@implementation ZNMenuView

- (id)initWithFrame:(CGRect)frame andDelegate:(id<ZNMenuViewDelegate>)del
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        delegate = del;
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8f;
        
        menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 100) style:UITableViewStylePlain];
        menuTableView.delegate = self;
        menuTableView.dataSource = self;
        
        [menuTableView setExclusiveTouch:YES];
        
        [self addSubview:menuTableView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
        tapRecognizer.cancelsTouchesInView = NO;
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
        
        [self setHidden:YES];
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint location = [touch locationInView:menuTableView];
    CGSize size = menuTableView.bounds.size;
    return !(((location.x >= 0) && (location.x <= size.width))&&((location.y >= 0)&&(location.y <= size.height)));
}

- (void)openMenu:(id<ZNMenuView>)menuView fromPoint:(CGPoint)point {
    currentMenuView = menuView;
    [menuTableView reloadData];
    [self setHidden:NO];
    [menuTableView setFrame:CGRectMake(point.x, point.y, 0, 0)];
    
    [UIView animateWithDuration:0.25 animations:^{
        [menuTableView setFrame:CGRectMake(50, 50, 250, 250)];
    }];
    
}

- (void)closeMenu {
    [self setHidden:YES];
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

    if (currentMenuView) {
        NSArray *theGroup = (NSArray*)[[[currentMenuView menuGroups] allValues] objectAtIndex:section];
        return [theGroup count];
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *group = [[[currentMenuView menuGroups] allValues] objectAtIndex:indexPath.section];
    ZNMenuItem *i = [group objectAtIndex:indexPath.row];
    
    cell.textLabel.text = i.title;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (currentMenuView) {
        return [[currentMenuView menuGroups] count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (currentMenuView) {
        return [[[currentMenuView menuGroups] allKeys] objectAtIndex:section];
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *group = [[[currentMenuView menuGroups] allValues] objectAtIndex:indexPath.section];
    ZNMenuItem *i = [group objectAtIndex:indexPath.row];
    
    [self setHidden:YES];
    
    if (i.selector) {
        switch (i.target) {
            case kMenuTargetSocial:
                [delegate switchToMainView:[delegate socialView]];
                [[delegate socialView] performSelector:i.selector withObject:i.selectedItem];
                break;
                
            case kMenuTargetBase:
                //[delegate switchToMainView:[delegate socialView]];
                [[delegate baseViewController] performSelector:i.selector withObject:i.selectedItem];
                break;
                
            case kMenuTargetMap:
                [delegate switchToMainView:[delegate mapView]];
                [[delegate mapView] performSelector:i.selector withObject:i.selectedItem];
                break;
                
            case kMenuTargetMedia:
                [delegate switchToMainView:[delegate mediaView]];
                [[delegate mediaView] performSelector:i.selector withObject:i.selectedItem];
                break;
                
            case kMenuTargetTimeline:
                [delegate switchToMainView:[delegate timelineView]];
                [[delegate timelineView] performSelector:i.selector withObject:i.selectedItem];
                break;
                
            case kMenuTargetSettings:
            {
                //ZNSettings *s = [ZNSettings shared];   
                [[ZNSettings shared] performSelector:i.selector withObject:i.selectedItem];
            }
                
                
                //
                
                //ZNSettings *s = [ZNSettings shared];
                //[s performSelector:i.selector withObject:i.selectedItem];
                break;
                
            default:
                break;
        }
    }
    
}


@end

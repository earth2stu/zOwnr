//
//  ZNEventDetailsViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 29/05/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNEventDetailsViewController.h"


@implementation ZNEventDetailsViewController

@synthesize photoGroup;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    if (!event) {
        event = [[Event alloc] init];
    }
    
    if (photoGroup) {
        NSDictionary *firstPhoto = [photoGroup objectAtIndex:0];
        NSDictionary *lastPhoto = [photoGroup objectAtIndex:[photoGroup count] - 1];
        
        startCell.detailTextLabel.text = [firstPhoto objectForKey:@"DateTime"];
        finishCell.detailTextLabel.text = [lastPhoto objectForKey:@"DateTime"];
        
        NSMutableArray *lats = [NSMutableArray array];
        NSMutableArray *longs = [NSMutableArray array];
        
        
        for (NSDictionary *d in photoGroup) {
            [lats addObject:(NSNumber*)[d valueForKey:@"Latitude"]];
            [longs addObject:(NSNumber*)[d valueForKey:@"Longitude"]];
        }
        
        float minLatitude = [[lats valueForKeyPath:@"@min.floatValue"] floatValue];
        float maxLatitude = [[lats valueForKeyPath:@"@max.floatValue"] floatValue];
        float minLongitude = [[longs valueForKeyPath:@"@min.floatValue"] floatValue];
        float maxLongitude = [[longs valueForKeyPath:@"@max.floatValue"] floatValue];
        
        
        
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Date Time delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    currentSender = sender;
    
    if ([sender isEqual:startCell]) {
        ZNDateTimeViewController *dtvc = (ZNDateTimeViewController*)segue.destinationViewController;
        dtvc.delegate = self;
        //dtvc.theDate = event.startTime;
    }
    
    if ([sender isEqual:finishCell]) {
        ZNDateTimeViewController *dtvc = (ZNDateTimeViewController*)segue.destinationViewController;
        dtvc.delegate = self;
        //dtvc.theDate = event.endTime;
    }
}

- (void)dateTimeViewController:(ZNDateTimeViewController *)dateTimeViewController didSetDate:(NSDate *)dateSet {
    if ([currentSender isEqual:startCell]) {
        event.startTime = dateSet;
    }
    
    if ([currentSender isEqual:finishCell]) {
        event.endTime = dateSet;
    }
}

@end

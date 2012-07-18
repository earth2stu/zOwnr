//
//  ZNEventSuggestionTableViewController.m
//  zOwnr
//
//  Created by Stuart Watkins on 29/05/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "ZNEventSuggestionTableViewController.h"
#import "ZNEventDetailsViewController.h"

@interface ZNEventSuggestionTableViewController() {
    ALAssetsLibrary *library;
}

- (void)groupEvents;

@end


@implementation ZNEventSuggestionTableViewController

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
    
    // Do any additional setup after loading the view, typically from a nib.
    
    loadingView = [[ZNTableLoadingViewController alloc] initWithDelegate:self andMessage:@"Finding events..."];
    
    [self.view addSubview:loadingView.view];
    
    photosWithInfo = [NSMutableArray array];
    
    // Get the assets library
    
    library = [[ALAssetsLibrary alloc] init];
    
    
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
     
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     
     {
         
         
         
         // Within the group enumeration block, filter to enumerate just photos.
         
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         
         
         
         [group enumerateAssetsUsingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
          
          {
              
              
              
              // The end of the enumeration is signaled by asset == nil.
              
              if (alAsset) {
                  
                  ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                
                  
                  NSMutableDictionary *thisPhoto = [NSMutableDictionary dictionary];
                  [thisPhoto setValue:representation.url forKey:@"URL"];
                  BOOL useThisPhoto = NO;
                  
                  NSDictionary *imageMetadata = [representation metadata];
                  
                  // Do something interesting with the metadata.
                  
                  
                  
                  NSArray *keyArray =  [imageMetadata allKeys];
                  
                  int count = [keyArray count];
                  
                  for (int i=0; i < count; i++) {
                      
                      NSDictionary *tmp = [imageMetadata objectForKey:[ keyArray objectAtIndex:i]];
                      
                      if ([tmp isKindOfClass:[NSDictionary class]]) {
                          //NSLog(@"woot");
                          
                          NSString *thisKey = [keyArray objectAtIndex:i];
                          
                          
                          
                          if ([thisKey isEqualToString:@"{TIFF}"]) {
                              NSString *dateTime = [tmp objectForKey:@"DateTime"];
                              //NSLog(@"this file %@ taken on %@", representation.url, dateTime);
                              [thisPhoto setValue:dateTime forKey:@"DateTime"];
                              if (dateTime) {
                                  useThisPhoto = YES;
                              } 
                          }
                          
                          NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                          [nf setNumberStyle:NSNumberFormatterDecimalStyle];
                          
                          if ([thisKey isEqualToString:@"{GPS}"]) {
                              NSNumber *latitude = [tmp objectForKey:@"Latitude"];
                              NSNumber *longitude = [tmp objectForKey:@"Longitude"];
                              //NSLog(@"this file %@ taken at %@, %@", representation.filename, latitude, longitude);
                              [thisPhoto setValue:latitude forKey:@"Latitude"];
                              [thisPhoto setValue:longitude forKey:@"Longitude"];
                          }
                          
                                                    

                          
                      }
                      
                                            
                      
                      NSLog(@"key=%@, value=%@", [keyArray objectAtIndex:i], tmp);
                      
                      
                      
                  }
                  
                  
                  
                  if (useThisPhoto) {
                      [photosWithInfo addObject:thisPhoto];
                  }
                  
                  
                  
                  
                  
                  
                  
              }
              
              
              
              
          }];
         
         
         if (group == NULL && stop) {
             [self groupEvents];
         }
         
         
     }
     
                         failureBlock: ^(NSError *error)
     
     {
         
         // Typically you should handle an error more gracefully than this.
         
         NSLog(@"No groups");
         
     }];
    
    
    
    
    
    
}

- (void)groupEvents {
    // should have photos now .. sort them by date
    
    NSSortDescriptor *timeSD = [NSSortDescriptor sortDescriptorWithKey: @"DateTime" ascending: YES];
    
    chronoPhotos = [photosWithInfo sortedArrayUsingDescriptors:[NSArray arrayWithObject:timeSD]];
    
    //NSLog(@"photos in order:%@", chronoPhotos);
    
    NSMutableArray *timeDiffs = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YY:MM:dd HH:mm:ss";
    
    NSDate *lastDate;
    
    NSTimeInterval threshhold = 3600 * 3;
    
    int groupNum = -1;
    BOOL betweenGroups = YES;
    
    photoGroups = [NSMutableArray array];
    
    for (int i = 0; i < [chronoPhotos count]; i++) {
        NSMutableDictionary *photo = [chronoPhotos objectAtIndex:i];
        NSDate *thisDate = [dateFormatter dateFromString:[photo valueForKey:@"DateTime"]];
        
        if (lastDate) {
            
            NSTimeInterval interval = [thisDate timeIntervalSinceDate:lastDate];
            if (interval < threshhold) {
                // set both these photos to belong to the same group
                
                if (betweenGroups) {
                    groupNum++;
                    
                    NSMutableArray *group = [NSMutableArray array];
                    [photoGroups addObject:group];
                    
                    betweenGroups = NO;
                }
                
                NSMutableArray *group = [photoGroups objectAtIndex:groupNum];
                
                
                
                NSMutableDictionary *lastPhoto = [chronoPhotos objectAtIndex:(i-1)];
                
                //[lastPhoto setValue:[NSNumber numberWithInt:groupNum] forKey:@"Group"];
                if (![group containsObject:lastPhoto]) {
                    [group addObject:lastPhoto];
                }
                
                
                //[photo setValue:[NSNumber numberWithInt:groupNum] forKey:@"Group"];
                [group addObject:photo];
                
                
                
            } else {
                betweenGroups = YES;
            }
            
            
            //[timeDiffs addObject:];
            //[timeDiffs addObject:[NSExpression expressionForConstantValue:[NSNumber numberWithDouble:interval]]];
            
        }
        
        lastDate = thisDate;

    }
    
    //NSLog(@"grouped photos in order:%@", photoGroups);
    
    
    [self.tableView reloadData];
    
    [loadingView close];
    
    /*
        
    NSLog(@"time diffs in seconds:%@", timeDiffs);
    
    
    //NSNumber *stddev = (NSNumber*)[NSExpression expressionForFunction:@"stddev:" arguments:timeDiffs];
    
    //NSLog(@"stddev:%@", stddev);
    
    NSExpression *blah = [NSExpression expressionForFunction:@"stddev:" arguments:timeDiffs];
    id result = [blah expressionValueWithObject:nil context:nil];
    
    NSLog(@"result:%@", result);
    */
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (photoGroups) {
        return [photoGroups count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupImageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    
    NSArray *group = [photoGroups objectAtIndex:indexPath.row];
    NSDictionary *photo = [group objectAtIndex:0];
    NSURL *url = [photo valueForKey:@"URL"];
    NSString *dateTime = [photo valueForKey:@"DateTime"];
    cell.textLabel.text = dateTime;
    cell.imageView.image = [UIImage imageNamed:@"first.png"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i photos", [group count]];
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset)
    {
        //NSLog(@"This debug string was logged after this function was done");
        [cell.imageView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
        
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock  = ^(NSError *error)
    {
        NSLog(@"Unresolved error: %@, %@", error, [error localizedDescription]);
    };
    
    [library assetForURL:url
                    resultBlock:resultBlock
                   failureBlock:failureBlock];
    
    
    
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    ZNEventDetailsViewController *vc = (ZNEventDetailsViewController*)segue.destinationViewController;
    UITableViewCell *tvc = (UITableViewCell*)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
    vc.photoGroup = [photoGroups objectAtIndex:indexPath.row];
    
    
}

@end

//
//  W5AssetTableViewController.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

// Tips from:
// ELC iCodeBlog - 
// NSScreencast - http://nsscreencast.com/episodes/8-automatic-uitableview-paging

#import "W5AssetTableViewController.h"
#import "W5AssetsTableViewCell.h"
#import "W5AssetPickerController.h"
#import "W5AssetWrapper.h"

#define FETCH_SIZE 25
#define ASSETS_PER_ROW_V 4.0
#define ASSETS_PER_ROW_H 6.0

@interface W5AssetTableViewController () <W5AssetsTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *fetchedAssets;
@property (nonatomic, readonly) NSInteger assetsPerRow;
@property (nonatomic, readonly) NSArray *selectedAssets;
@end


@implementation W5AssetTableViewController

@synthesize assetsGroup = _assetsGroup;
@synthesize fetchedAssets = _fetchedAssets;
@synthesize assetsPerRow =_assetsPerRow;
@dynamic selectedAssets;

#pragma mark - View Lifecycle

#define TABLEVIEW_INSETS UIEdgeInsetsMake(2, 0, 2, 0);

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    
    // Setup the toolbar if there are items in the navigationController's toolbarItems.
    if (self.navigationController.toolbarItems.count > 0) {
        self.toolbarItems = self.navigationController.toolbarItems;
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Hide the toolbar in the event it's being displayed.
    if (self.navigationController.toolbarItems.count > 0) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    self.navigationItem.title = @"Loading";
    
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                           target:self 
                                                                                           action:@selector(doneButtonAction:)];
    
    // TableView configuration.
    self.tableView.contentInset = TABLEVIEW_INSETS;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    
    
    // Fetch the assets.
    [self fetchAssets];
}


#pragma mark - Getters

- (NSMutableArray *)fetchedAssets
{
    if (!_fetchedAssets) {
        _fetchedAssets = [NSMutableArray arrayWithCapacity:FETCH_SIZE];
    }
    return _fetchedAssets;
}

- (NSInteger)assetsPerRow
{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
        self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        return ASSETS_PER_ROW_H;
    } else {
        return ASSETS_PER_ROW_V;
    }
}

- (NSArray *)selectedAssets
{
    NSDate *start = [NSDate date];
    DLog(@"\n\nGetting selected photos.");
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
    NSArray *matches = [self.fetchedAssets filteredArrayUsingPredicate:predicate];
    
    NSDate *methodFinish = [NSDate date];
    NSLog(@"Done.");
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
    NSLog(@"Execution Time: %f\n\n", executionTime);
    
    DLog(@"Matches: %@", matches);
    
    
    
    
    start = [NSDate date];
    DLog(@"\n\nGetting real assets.");
    
    NSMutableArray *selectedAssets = [NSMutableArray arrayWithCapacity:[matches count]];
    for (W5AssetWrapper *wrapper in matches) {
        [selectedAssets addObject:wrapper.asset];
    }
    
    methodFinish = [NSDate date];
    NSLog(@"Done.");
    executionTime = [methodFinish timeIntervalSinceDate:start];
    NSLog(@"Execution Time: %f\n\n", executionTime);
    
    return selectedAssets;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];
}


#pragma mark - Fetching Code

- (void)fetchAssets
{
    // TODO: Listen to ALAssetsLibrary changes in order to update the library if it changes. 
    // (e.g. if user closes, opens Photos and deletes/takes a photo, we'll get out of range/other error when they come back.
    // IDEA: Perhaps the best solution, since this is a modal controller, is to close the modal controller.
    
    dispatch_queue_t enumQ = dispatch_queue_create("AssetEnumeration", NULL);
    
    dispatch_async(enumQ, ^{
        
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (!result || index == NSNotFound) {
                DLog(@"Done fetching.");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
                });
                
                return;
            }
            
            W5AssetWrapper *assetWrapper = [[W5AssetWrapper alloc] initWithAsset:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.fetchedAssets addObject:assetWrapper];
                
            });
            
        }];
    });
    
    dispatch_release(enumQ);
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - Actions

- (void)doneButtonAction:(id)sender
{     
    // The navigationController is actually a subclass of W5AssetPickerController. It's delegate conforms to the
    // W5AssetPickerControllerDelegate protocol, an extended version of the UINavigationControllerDelegate protocol.
    id <W5AssetPickerControllerDelegate> delegate = (id <W5AssetPickerControllerDelegate>)self.navigationController.delegate;
    
    if ([delegate respondsToSelector:@selector(assetPickerController:didFinishPickingMediaWithAssets:)]) {
        
        [delegate assetPickerController:(W5AssetPickerController *)self.navigationController didFinishPickingMediaWithAssets:self.selectedAssets];
    }
}


#pragma mark - W5AssetsTableViewCellDelegate Methods

- (void)assetsTableViewCell:(W5AssetsTableViewCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DLog(@"Column: %d", column);
    
    // Calculate the index of the corresponding asset.
    NSUInteger assetIndex = indexPath.row * self.assetsPerRow + column;
    
    
    DLog(@"Asset Index: %d", assetIndex);
    
    W5AssetWrapper *assetWrapper = [self.fetchedAssets objectAtIndex:assetIndex];
    assetWrapper.selected = selected;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"Num Rows: %d", (self.fetchedAssets.count + self.assetsPerRow - 1) / self.assetsPerRow);
    
    return (self.fetchedAssets.count + self.assetsPerRow - 1) / self.assetsPerRow;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath
{    
    NSRange assetRange;
    assetRange.location = indexPath.row * self.assetsPerRow;
    assetRange.length = self.assetsPerRow;
    
    // Prevent the range from exceeding the array length.
    if (assetRange.length > self.fetchedAssets.count - assetRange.location) {
        assetRange.length = self.fetchedAssets.count - assetRange.location;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:assetRange];
    
    // Return the range of assets from fetchedAssets.
    return [self.fetchedAssets objectsAtIndexes:indexSet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetCellIdentifier = @"W5AssetCell";
    W5AssetsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AssetCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[W5AssetsTableViewCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:AssetCellIdentifier];        
    } else {
        
        cell.cellAssetViews = [self assetsForIndexPath:indexPath];
    }
    cell.delegate = self;
    
    return cell;
}


#pragma mark - Table view delegate

#define ROW_HEIGHT 79.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	return ROW_HEIGHT;
}

@end

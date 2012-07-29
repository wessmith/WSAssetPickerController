//
//  WSAlbumTableViewController.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "WSAlbumTableViewController.h"
#import "WSAssetPickerState.h"
#import "WSAssetTableViewController.h"


@interface WSAlbumTableViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *assetGroups; // Model (all groups of assets).
@end


@implementation WSAlbumTableViewController

@synthesize assetPickerState = _assetPickerState;
@synthesize assetsLibrary = _assetsLibrary;
@synthesize assetGroups = _assetGroups;


#pragma mark - Getters 

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)assetGroups
{
    if (!_assetGroups) {
        _assetGroups = [NSMutableArray array];
    }
    
    return _assetGroups;
}

#pragma mark - View Lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    
    self.assetPickerState.state = WSAssetPickerStatePickingAlbum;
    
    DLog(@"\n*********************************\n\nShowing Album Picker\n\n*********************************");
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Loading…";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                           target:self 
                                                                                           action:@selector(cancelButtonAction:)];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // If group is nil, the end has been reached.
        if (group == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.title = @"Albums";
            });
            return;
        }
        
        // Add the group to the array.
        [self.assetGroups addObject:group];
        
        // Reload the tableview on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failureBlock:^(NSError *error) {
        // TODO: User denied access. Tell them we can't do anything.
    }];
}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma  mark - Actions

- (void)cancelButtonAction:(id)sender 
{    
    self.assetPickerState.state = WSAssetPickerStatePickingCancelled;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WSAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get the group from the datasource.
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]]; // TODO: Make this a delegate choice.
    
    // Setup the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]]; // TODO: Make this a delegate choice.
    
    WSAssetTableViewController *assetTableViewController = [[WSAssetTableViewController alloc] initWithStyle:UITableViewStylePlain];
    assetTableViewController.assetPickerState = self.assetPickerState;
    assetTableViewController.assetsGroup = group;
    
    [self.navigationController pushViewController:assetTableViewController animated:YES];
}

#define ROW_HEIGHT 57.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	return ROW_HEIGHT;
}

@end

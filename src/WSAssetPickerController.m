//
//  WSAssetPickerController.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "WSAssetPickerController.h"
#import "WSAssetPickerState.h"
#import "WSAlbumTableViewController.h"

@interface WSAssetPickerController ()
@property (nonatomic, strong) WSAssetPickerState *assetPickerState;
@property (nonatomic, readwrite) NSUInteger selectedCount;
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;
@end


@implementation WSAssetPickerController

@dynamic selectedAssets;

@synthesize assetPickerState = _assetPickerState;
@synthesize selectedCount = _selectedCount;
@synthesize originalStatusBarStyle = _originalStatusBarStyle;


#pragma mark - Initialization

- (id)initWithDelegate:(id <WSAssetPickerControllerDelegate>)delegate;
{
    // Create the Album TableView Controller.
    WSAlbumTableViewController *albumTableViewController = [[WSAlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    albumTableViewController.assetPickerState = self.assetPickerState;
    
    if ((self = [super initWithRootViewController:albumTableViewController])) {
        
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.delegate = delegate;
    }
    
    return self;
}

#define STATE_KEY @"state"
#define SELECTED_COUNT_KEY @"selectedCount"

- (WSAssetPickerState *)assetPickerState
{
    if (!_assetPickerState) {
        _assetPickerState = [[WSAssetPickerState alloc] init];
    }
    return _assetPickerState;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    // Start observing state changes and selectedCount changes.
    [_assetPickerState addObserver:self forKeyPath:STATE_KEY options:NSKeyValueObservingOptionNew context:NULL];
    [_assetPickerState addObserver:self forKeyPath:SELECTED_COUNT_KEY options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle animated:YES];
    
    // Stop observing state changes and selectedCount changes.
    [_assetPickerState removeObserver:self forKeyPath:STATE_KEY];
    [_assetPickerState removeObserver:self forKeyPath:SELECTED_COUNT_KEY];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if (![object isEqual:self.assetPickerState]) return;
    
    if ([STATE_KEY isEqualToString:keyPath]) {     
        
        DLog(@"State Changed: %@", change);
        
        // Cast the delegate to the assetPickerDelegate.
        id <WSAssetPickerControllerDelegate> delegate = (id <WSAssetPickerControllerDelegate>)self.delegate;
        
        if (WSAssetPickerStatePickingCancelled == self.assetPickerState.state) {
            if ([delegate conformsToProtocol:@protocol(WSAssetPickerControllerDelegate)]) {
                [delegate assetPickerControllerDidCancel:self];
            }
        } else if (WSAssetPickerStatePickingDone == self.assetPickerState.state) {
            if ([delegate conformsToProtocol:@protocol(WSAssetPickerControllerDelegate)]) {
                [delegate assetPickerController:self didFinishPickingMediaWithAssets:self.assetPickerState.selectedAssets];
            }
        }
    } else if ([SELECTED_COUNT_KEY isEqualToString:keyPath]) {
        
        self.selectedCount = self.assetPickerState.selectedCount;
        DLog(@"Total selected: %d", self.assetPickerState.selectedCount);
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

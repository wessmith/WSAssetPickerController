//
//  W5AssetPickerController.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetPickerController.h"
#import "W5AssetPickerState.h"
#import "W5AlbumTableViewController.h"

@interface W5AssetPickerController ()
@property (nonatomic, strong) W5AssetPickerState *assetPickerState;
@property (nonatomic, readwrite) NSUInteger selectedCount;
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;
@end


@implementation W5AssetPickerController

@dynamic selectedAssets;

@synthesize assetPickerState = _assetPickerState;
@synthesize selectedCount = _selectedCount;
@synthesize originalStatusBarStyle = _originalStatusBarStyle;


#pragma mark - Initialization

- (id)initWithDelegate:(id <W5AssetPickerControllerDelegate>)delegate;
{
    // Create the Album TableView Controller.
    W5AlbumTableViewController *albumTableViewController = [[W5AlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
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

- (W5AssetPickerState *)assetPickerState
{
    if (!_assetPickerState) {
        _assetPickerState = [[W5AssetPickerState alloc] init];
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
        id <W5AssetPickerControllerDelegate> delegate = (id <W5AssetPickerControllerDelegate>)self.delegate;
        
        if (W5AssetPickerStatePickingCancelled == self.assetPickerState.state) {
            if ([delegate conformsToProtocol:@protocol(W5AssetPickerControllerDelegate)]) {
                [delegate assetPickerControllerDidCancel:self];
            }
        } else if (W5AssetPickerStatePickingDone == self.assetPickerState.state) {
            if ([delegate conformsToProtocol:@protocol(W5AssetPickerControllerDelegate)]) {
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

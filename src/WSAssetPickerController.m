//
//  WSAssetPickerController.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "WSAssetPickerController.h"
#import "WSAssetPickerState.h"
#import "WSAlbumTableViewController.h"

#define SELECTED_COUNT_KEY @"selectedCount"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface WSAssetPickerController ()
@property (nonatomic, strong) WSAssetPickerState *assetPickerState;
@property (nonatomic, readwrite) NSUInteger selectedCount;
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;

@property (nonatomic, strong) PickerDidFailBlock pickerDidFailBlock;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation WSAssetPickerController

@dynamic selectedAssets;

#pragma mark - Initialization -

////////////////////////////////////////////////////////////////////////////////
+ (WSAssetPickerController *)pickerWithAssetsLibrary:(ALAssetsLibrary *)library
{
    return [[self class] pickerWithAssetsLibrary:library
                                 completionBlock:nil
                                     cancelBlock:nil
                                    failureBlock:nil];
}

////////////////////////////////////////////////////////////////////////////////
+ (WSAssetPickerController *)pickerWithCompletionBlock:(PickerDidCompleteBlock)completionBlock
                                           cancelBlock:(PickerDidCancelBlock)cancelBlock
                                          failureBlock:(PickerDidFailBlock)failureBlock
{
    return [[self class] pickerWithAssetsLibrary:nil
                                 completionBlock:completionBlock
                                     cancelBlock:cancelBlock
                                    failureBlock:failureBlock];
}

////////////////////////////////////////////////////////////////////////////////
+ (WSAssetPickerController *)pickerWithAssetsLibrary:(ALAssetsLibrary *)library
                                     completionBlock:(PickerDidCompleteBlock)completionBlock
                                         cancelBlock:(PickerDidCancelBlock)cancelBlock
                                        failureBlock:(PickerDidFailBlock)failureBlock
{
    WSAssetPickerController *picker = [[[self class] alloc] init];
    picker.assetPickerState.assetsLibrary = library;
    picker.assetPickerState.pickerDidCompleteBlock = completionBlock;
    picker.assetPickerState.pickerDidCancelBlock = cancelBlock;
    picker.assetPickerState.pickerDidFailBlock = failureBlock;
    return picker;
}

////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    // Create the Album TableView Controller.
    WSAlbumTableViewController *albumTableViewController = [[WSAlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    albumTableViewController.assetPickerState = self.assetPickerState;
    
    self = [super initWithRootViewController:albumTableViewController];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id <WSAssetPickerControllerDelegate>)delegate
{
    WSAssetPickerController *picker = [[[self class] alloc] init];
    picker.delegate = delegate;
    return picker;
}

////////////////////////////////////////////////////////////////////////////////
- (WSAssetPickerState *)assetPickerState
{
    if (!_assetPickerState) {
        _assetPickerState = [[WSAssetPickerState alloc] init];
    }
    return _assetPickerState;
}

////////////////////////////////////////////////////////////////////////////////
- (void)setSelectionLimit:(NSInteger)selectionLimit
{
    if (_selectionLimit != selectionLimit) {
        _selectionLimit = selectionLimit;
        self.assetPickerState.selectionLimit = _selectionLimit;
    }
}

#pragma mark - Block Setters -

////////////////////////////////////////////////////////////////////////////////
- (void)setPickerDidFailBlock:(PickerDidFailBlock)block
{
    // Hang on to the library consumer's fail block locally and set a private block.
    // This provides an opportunity to change the UI before notifying the consumer of the failure.
    self.pickerDidFailBlock = block;
    
    __weak __typeof__(self) weakSelf = self;
    [self.assetPickerState setPickerDidFailBlock:^(NSError *error) {
        
        // Forward the error.
        if (weakSelf.pickerDidFailBlock)
            weakSelf.pickerDidFailBlock(error);
    }];
}

////////////////////////////////////////////////////////////////////////////////
- (void)setPickerDidCancelBlock:(PickerDidCancelBlock)block
{
    self.assetPickerState.pickerDidCancelBlock = block; 
}

////////////////////////////////////////////////////////////////////////////////
- (void)setPickerDidCompleteBlock:(PickerDidCompleteBlock)block
{
    self.assetPickerState.pickerDidCompleteBlock = block;
}

#pragma mark - Overrides -

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak __typeof__(self) weakSelf = self;
    
    // Set a cancel block—if not already set—so we can try notifying a delegate.
    if (self.assetPickerState.pickerDidCancelBlock == nil) {
        [self.assetPickerState setPickerDidCancelBlock:^{
            if ([weakSelf.delegate conformsToProtocol:@protocol(WSAssetPickerControllerDelegate)])
                [weakSelf.delegate performSelector:@selector(assetPickerControllerDidCancel:) withObject:weakSelf];
        }];
    }

    // Set a complete block—if not already set—so we can try notifying a delegate.
    if (self.assetPickerState.pickerDidCompleteBlock == nil) {
        [self.assetPickerState setPickerDidCompleteBlock:^(NSDictionary *info) {
            if ([weakSelf.delegate conformsToProtocol:@protocol(WSAssetPickerControllerDelegate)]) {
                NSArray *selectedAssets = [weakSelf.assetPickerState.info objectForKey:WSAssetPickerSelectedAssets];
                [weakSelf.delegate performSelector:@selector(assetPickerController:didFinishPickingMediaWithAssets:) withObject:weakSelf withObject:selectedAssets];
            }
        }];
    }
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    // Start observing selectedCount changes.
    [_assetPickerState addObserver:self forKeyPath:SELECTED_COUNT_KEY options:NSKeyValueObservingOptionNew context:NULL];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle animated:YES];
    
    // Stop observing selectedCount changes.
    [_assetPickerState removeObserver:self forKeyPath:SELECTED_COUNT_KEY];
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - KVO -

////////////////////////////////////////////////////////////////////////////////
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if (![object isEqual:self.assetPickerState]) return;
    
    if ([SELECTED_COUNT_KEY isEqualToString:keyPath]) {
        
        self.selectedCount = self.assetPickerState.selectedCount;
        DLog(@"Total selected: %d", self.assetPickerState.selectedCount);
    }
}

@end

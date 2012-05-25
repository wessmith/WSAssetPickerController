//
//  W5AssetPickerController.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol W5AssetPickerControllerDelegate;

@interface W5AssetPickerController : UINavigationController

@property (nonatomic, readonly) NSArray *selectedAssets;
@property (nonatomic, readonly) NSUInteger selectedCount; // Observable.

// Designated initializer.
- (id)initWithDelegate:(id<W5AssetPickerControllerDelegate>)delegate;

@end

@protocol W5AssetPickerControllerDelegate <UINavigationControllerDelegate>

- (void)assetPickerControllerDidCancel:(W5AssetPickerController *)sender;
- (void)assetPickerController:(W5AssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets;

@optional
//- (void)assetPickerController:(W5AssetPickerController *)sender didChangeSelectionState:(BOOL)selected forAsset:(ALAsset *)asset;

@end
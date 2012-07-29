//
//  WSAssetPickerController.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSAssetPickerControllerDelegate;

@interface WSAssetPickerController : UINavigationController

@property (nonatomic, readonly) NSArray *selectedAssets;
@property (nonatomic, readonly) NSUInteger selectedCount; // Observable via key-value observing.

// Designated initializer.
- (id)initWithDelegate:(id<WSAssetPickerControllerDelegate>)delegate;

@end


@protocol WSAssetPickerControllerDelegate <UINavigationControllerDelegate>

// Called when the 'cancel' button it tapped.
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender;

// Called when the done button is tapped.
- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets;

@end
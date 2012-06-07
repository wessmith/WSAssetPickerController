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
@property (nonatomic, readonly) NSUInteger selectedCount; // Observable via key-value observing.

// Designated initializer.
- (id)initWithDelegate:(id<W5AssetPickerControllerDelegate>)delegate;

@end


@protocol W5AssetPickerControllerDelegate <UINavigationControllerDelegate>

// Called when the 'cancel' button it tapped.
- (void)assetPickerControllerDidCancel:(W5AssetPickerController *)sender;

// Called when the done button is tapped.
- (void)assetPickerController:(W5AssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets;

@end
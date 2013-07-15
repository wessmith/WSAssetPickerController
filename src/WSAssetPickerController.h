//
//  WSAssetPickerController.h
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

#import <UIKit/UIKit.h>

@protocol WSAssetPickerControllerDelegate;

@interface WSAssetPickerController : UINavigationController

/** @name Properties */

/**  The assets that are selected in the picker view. */
@property (nonatomic, readonly) NSArray *selectedAssets;

/** A count of the selected assets. This can be observed via KVO. */
@property (nonatomic, readonly) NSUInteger selectedCount;

/** Limits the number of assets that can be selected in the picker view. */
@property (nonatomic, readwrite) NSInteger selectionLimit;

/** 
 Initializes an instance of `assetPickerViewController`.
 
 @param delegate An object conforming to the `WSAssetPickerControllerDelegate` protocol.
 
 @discussion This method is deprecated. @see `initWithAssetsLibrary:`.
 */
- (id)initWithDelegate:(id <WSAssetPickerControllerDelegate>)delegate;

@end

/** @name Asset Picker Controller Delegate Protocol */

@protocol WSAssetPickerControllerDelegate <UINavigationControllerDelegate>

/**
 Tells the delegate that the user cancelled the pick operation.
 
 @param sender The controller object managing the asset picker interface.
 */
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender;

/**
 Tells the delegate that the user finished picking assets.
 
 @param sender The controller object managing the asset picker interface.
 @param assets An array of `ALAsset` objects selected by the user.
 
 @discussion The lifetimes of the `ALAsset` objects are tied to the lifetime of the `assetPickerController`. This means that you must keep a strong reference to the `assetPickerSontroller` until you are finished using `ALAsset` objects selected in the picker.
 */
- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets;

/** 
 Tells the delegate that the user attempted to select more than the `selectionLimit`.

 @param sender The controller object managing the asset picker interface.
 */
- (void)assetPickerControllerDidReachSelectionLimit:(WSAssetPickerController *)sender;

@end
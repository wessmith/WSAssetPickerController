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
#import <AssetsLibrary/AssetsLibrary.h>

extern NSString *const WSAssetPickerAssetsOwningLibraryInstance;
extern NSString *const WSAssetPickerURLsForSelectedAssets;
extern NSString *const WSAssetPickerSelectedAssets;

typedef void (^PickerDidCompleteBlock)(NSDictionary *info);
typedef void (^PickerDidCancelBlock)(void);
typedef void (^PickerDidFailBlock)(NSError *error);

@protocol WSAssetPickerControllerDelegate;

@interface WSAssetPickerController : UINavigationController

@property (nonatomic, readonly) NSArray *selectedAssets;
@property (nonatomic, readonly) NSUInteger selectedCount; // Observable via key-value observing.

// Limit the number of assets that can be selected.
@property (nonatomic, readwrite) NSInteger selectionLimit;

+ (WSAssetPickerController *)pickerWithAssetsLibrary:(ALAssetsLibrary *)library;

+ (WSAssetPickerController *)pickerWithCompletionBlock:(PickerDidCompleteBlock)completionBlock
                                           cancelBlock:(PickerDidCancelBlock)cancelBlock
                                          failureBlock:(PickerDidFailBlock)failureBlock;

+ (WSAssetPickerController *)pickerWithAssetsLibrary:(ALAssetsLibrary *)library
                                          completionBlock:(PickerDidCompleteBlock)completionBlock
                                              cancelBlock:(PickerDidCancelBlock)cancelBlock
                                             failureBlock:(PickerDidFailBlock)failureBlock;

- (id)initWithDelegate:(id<WSAssetPickerControllerDelegate>)delegate DEPRECATED_ATTRIBUTE;

- (void)setPickerDidFailBlock:(PickerDidFailBlock)block;

- (void)setPickerDidCancelBlock:(PickerDidCancelBlock)block;

- (void)setPickerDidCompleteBlock:(PickerDidCompleteBlock)block;

@end


@protocol WSAssetPickerControllerDelegate <UINavigationControllerDelegate>

// Called when the 'cancel' button it tapped.
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender DEPRECATED_ATTRIBUTE;

// Called when the done button is tapped.
- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets DEPRECATED_ATTRIBUTE;

@end
//
//  WSAssetPickerState.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/24/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WSAssetPickerStateInitializing,
    WSAssetPickerStatePickingAlbum,
    WSAssetPickerStatePickingAssets,
    WSAssetPickerStatePickingDone,
    WSAssetPickerStatePickingCancelled
} WSAssetPickingState;

@interface WSAssetPickerState : NSObject
@property (nonatomic, readonly) NSArray *selectedAssets;
@property (nonatomic, readwrite) NSUInteger selectedCount;
@property (nonatomic, readwrite) WSAssetPickingState state;

- (void)changeSelectionState:(BOOL)selected forAsset:(ALAsset *)asset;

@end

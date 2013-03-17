//
//  WSAssetPickerState.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/24/12.
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

#import "WSAssetPickerState.h"
#import "WSAssetWrapper.h"

NSString *const WSAssetPickerAssetsOwningLibraryInstance = @"WSAssetPickerAssetsOwningLibraryInstance";
NSString *const WSAssetPickerURLsForSelectedAssets       = @"WSAssetPickerURLsForSelectedAssets";
NSString *const WSAssetPickerSelectedAssets              = @"WSAssetPickerSelectedAssets";

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface WSAssetPickerState ()
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssetsSet;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation WSAssetPickerState

@dynamic info;

////////////////////////////////////////////////////////////////////////////////
- (ALAssetsLibrary *)assetsLibrary
{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)info
{
    NSArray *selectedAssets   = self.selectedAssetsSet.array.copy;
    NSArray *urls             = [selectedAssets valueForKeyPath:@"defaultRepresentation.url"];
    
    return
    @{
        WSAssetPickerAssetsOwningLibraryInstance       : self.assetsLibrary,
        WSAssetPickerSelectedAssets                    : selectedAssets,
        WSAssetPickerURLsForSelectedAssets             : urls,
     };
}

////////////////////////////////////////////////////////////////////////////////
- (NSMutableOrderedSet *)selectedAssetsSet
{
    if (!_selectedAssetsSet) {
        _selectedAssetsSet = [NSMutableOrderedSet orderedSet];
    }
    return _selectedAssetsSet;
}

////////////////////////////////////////////////////////////////////////////////
- (void)clearSelectedAssets
{
    [self.selectedAssetsSet removeAllObjects];
    self.selectedCount = 0;
}

////////////////////////////////////////////////////////////////////////////////
- (void)sessionCanceled
{
    if (self.pickerDidCancelBlock)
        self.pickerDidCancelBlock();
}

////////////////////////////////////////////////////////////////////////////////
- (void)sessionCompleted
{
    if (self.pickerDidCompleteBlock)
        self.pickerDidCompleteBlock(self.info);
}

////////////////////////////////////////////////////////////////////////////////
- (void)sessionFailed:(NSError *)error
{
    if (self.pickerDidFailBlock)
        self.pickerDidFailBlock(error);
}

////////////////////////////////////////////////////////////////////////////////
- (void)changeSelectionState:(BOOL)selected forAsset:(ALAsset *)asset
{
    if (selected) {
        [self.selectedAssetsSet addObject:asset];
    } else {
        [self.selectedAssetsSet removeObject:asset];
    }
    
    // Update the observable count property.
    self.selectedCount = [self.selectedAssetsSet count];
}

@end

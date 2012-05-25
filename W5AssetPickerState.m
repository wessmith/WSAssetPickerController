//
//  W5AssetPickerState.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/24/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetPickerState.h"

@interface W5AssetPickerState ()
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssetsSet;
@end

@implementation W5AssetPickerState

@dynamic selectedAssets;
@synthesize selectedAssetsSet = _selectedAssetsSet;
@synthesize selectedCount = _selectedCount;
@synthesize state = _state;

- (id)init
{
    if ((self = [super init])) {
        self.state = W5AssetPickerStateInitializing;
    }
    return self;
}

- (void)setState:(W5AssetPickingState)state
{
    _state = state;
    
    // Clear the selcted assets and count.
    if (W5AssetPickerStatePickingAlbum == _state) {
        [self.selectedAssetsSet removeAllObjects];
        self.selectedCount = 0;
    }
}

- (NSMutableOrderedSet *)selectedAssetsSet
{
    if (!_selectedAssetsSet) {
        _selectedAssetsSet = [NSMutableOrderedSet orderedSet];
    }
    return _selectedAssetsSet;
}

- (NSArray *)selectedAssets
{
    return [[self.selectedAssetsSet array] copy];
}

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

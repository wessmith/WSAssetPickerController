//
//  W5AssetWrapper.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/16/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetWrapper.h"

@implementation W5AssetWrapper

@synthesize asset = _asset;
@synthesize selected = _selected;

+ (W5AssetWrapper *)wrapperWithAsset:(ALAsset *)asset
{
    W5AssetWrapper *wrapper = [[W5AssetWrapper alloc] initWithAsset:asset];
    return wrapper;
}

- (id)initWithAsset:(ALAsset *)asset
{
    if ((self = [super init])) {
        _asset = asset;
    }
    return self;
}

@end

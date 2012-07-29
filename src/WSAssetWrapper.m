//
//  WSAssetWrapper.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/16/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "WSAssetWrapper.h"

@implementation WSAssetWrapper

@synthesize asset = _asset;
@synthesize selected = _selected;

+ (WSAssetWrapper *)wrapperWithAsset:(ALAsset *)asset
{
    WSAssetWrapper *wrapper = [[WSAssetWrapper alloc] initWithAsset:asset];
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

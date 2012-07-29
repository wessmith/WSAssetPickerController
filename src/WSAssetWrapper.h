//
//  WSAssetWrapper.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/16/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSAssetWrapper : NSObject

@property (nonatomic, strong, readonly) ALAsset *asset;
@property (nonatomic, getter = isSelected) BOOL selected;

+ (WSAssetWrapper *)wrapperWithAsset:(ALAsset *)asset;

- (id)initWithAsset:(ALAsset *)asset;

@end
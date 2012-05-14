//
//  W5AssetView.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface W5AssetView : UIView

+ (W5AssetView *)assetViewWithAsset:(ALAsset *)asset;

- (id)initWithAsset:(ALAsset *)asset;

@end

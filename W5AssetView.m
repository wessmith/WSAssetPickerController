//
//  W5AssetView.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetView.h"

@interface W5AssetView ()

@property (nonatomic, strong) ALAsset *asset;

@end


@implementation W5AssetView

@synthesize asset = _asset;

#define ASSET_VIEW_FRAME CGRectMake(0, 0, 75, 75)

+ (W5AssetView *)assetViewWithAsset:(ALAsset *)anAsset
{
    W5AssetView *assetView = [[W5AssetView alloc] initWithFrame:ASSET_VIEW_FRAME];
    assetView.asset = anAsset;
    
    return assetView;
}

- (id)initWithAsset:(ALAsset *)asset
{
    if ((self = [super initWithFrame:ASSET_VIEW_FRAME])) {
        
        self.asset = asset;
        
        UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:ASSET_VIEW_FRAME];
        assetImageView.contentMode = UIViewContentModeScaleToFill;
        assetImageView.image = [UIImage imageWithCGImage:self.asset.thumbnail];
        [self addSubview:assetImageView];
       
        
        // TODO: Overlay view here.
    }
    return self;
}
@end

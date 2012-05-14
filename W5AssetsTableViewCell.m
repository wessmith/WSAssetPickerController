//
//  W5AssetsTableViewCell.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetsTableViewCell.h"
#import "W5AssetView.h"


@implementation W5AssetsTableViewCell

@synthesize cellAssetViews = _cellAssetViews;

+ (W5AssetsTableViewCell *)assetsCellWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier
{
    W5AssetsTableViewCell *cell = [[W5AssetsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.cellAssetViews = assets;
    
    return cell;
}

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier
{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])) {
        
        self.cellAssetViews = assets;
    }
    
    return self;
}

- (void)setCellAssetViews:(NSArray *)assets
{
    // Remove the old W5AssetViews.
    for (UIView *assetView in [self subviews]) {
        [assetView removeFromSuperview];
    }
    
    // Create new W5AssetViews
    NSMutableArray *assetViews = [NSMutableArray arrayWithCapacity:[assets count]];
    for (ALAsset *asset in assets) {
        
        W5AssetView *assetView = [[W5AssetView alloc] initWithAsset:asset];
        [assetViews addObject:assetView];
    }
    
    _cellAssetViews = [assetViews copy];
}

#define ASSET_VIEW_FRAME CGRectMake(4, 2, 75, 75);

- (void)layoutSubviews
{
    CGRect frame = ASSET_VIEW_FRAME;
    
    for (W5AssetView *assetView in self.cellAssetViews) {
        
        assetView.frame = frame;
        [self addSubview:assetView];
        
        // Adjust the frame x-origin of the next assetView.
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

@end

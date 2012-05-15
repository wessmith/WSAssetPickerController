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

#define ASSET_VIEW_FRAME CGRectMake(0, 0, 75, 75)
#define ASSET_VIEW_PADDING 4

- (void)layoutSubviews
{
    // Calculate the container's width dynamically.
    float containerWidth = (self.cellAssetViews.count * ASSET_VIEW_FRAME.size.width) + ((self.cellAssetViews.count - 1) * ASSET_VIEW_PADDING);

    // Create the container frame dynamically.
    CGRect containerFrame;
    containerFrame.origin.x = (self.frame.size.width - containerWidth) / 2;
    containerFrame.origin.y = (self.frame.size.height - ASSET_VIEW_FRAME.size.height) / 2;
    containerFrame.size.width = containerWidth;
    containerFrame.size.height = ASSET_VIEW_FRAME.size.height;
    
    // Create a containing view with flexible margins.
    UIView *assetsContainerView = [[UIView alloc] initWithFrame:containerFrame];
    assetsContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | 
    UIViewAutoresizingFlexibleRightMargin | 
    UIViewAutoresizingFlexibleTopMargin | 
    UIViewAutoresizingFlexibleBottomMargin;
    
    CGRect frame = ASSET_VIEW_FRAME;
    
    for (W5AssetView *assetView in self.cellAssetViews) {
        
        assetView.frame = frame;
        [assetsContainerView addSubview:assetView];
        
        // Adjust the frame x-origin of the next assetView.
        frame.origin.x = frame.origin.x + frame.size.width + ASSET_VIEW_PADDING;
    }                                              
    
    [self addSubview:assetsContainerView];
}

@end

//
//  W5AssetsTableViewCell.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetsTableViewCell.h"
#import "W5AssetWrapper.h"
#import "W5AssetViewColumn.h"


@implementation W5AssetsTableViewCell

@synthesize delegate = _delegate;
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

- (void)stopObserving
{
    // Remove the old W5AssetViews.    
    for (W5AssetViewColumn *assetViewColumn in self.cellAssetViews) {
        
        [assetViewColumn removeObserver:self forKeyPath:@"isSelected"];
        
        [assetViewColumn removeFromSuperview];
    }
}

- (void)setCellAssetViews:(NSArray *)assets
{
    // Remove the old W5AssetViews.    
    [self stopObserving];
    
    // Create new W5AssetViews
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:[assets count]];
    
    for (W5AssetWrapper *assetWrapper in assets) {
        
        W5AssetViewColumn *assetViewColumn = [[W5AssetViewColumn alloc] initWithImage:[UIImage imageWithCGImage:assetWrapper.asset.thumbnail]];
        assetViewColumn.column = [assets indexOfObject:assetWrapper];
        assetViewColumn.selected = assetWrapper.isSelected;
        
        // Observe the column's isSelected property.
        [assetViewColumn addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew context:NULL];
        
        [columns addObject:assetViewColumn];
    }
    
    _cellAssetViews = columns;
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
    
    for (W5AssetViewColumn *assetView in self.cellAssetViews) {
        
        assetView.frame = frame;
        
        [assetsContainerView addSubview:assetView];
        
        // Adjust the frame x-origin of the next assetView.
        frame.origin.x = frame.origin.x + frame.size.width + ASSET_VIEW_PADDING;
    }                                              
    
    [self addSubview:assetsContainerView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isMemberOfClass:[W5AssetViewColumn class]]) {
        //DLog(@"%@", change);
        
        W5AssetViewColumn *column = (W5AssetViewColumn *)object;
        if ([self.delegate respondsToSelector:@selector(assetsTableViewCell:didSelectAsset:atColumn:)]) {

            [self.delegate assetsTableViewCell:self didSelectAsset:column.isSelected atColumn:column.column];
        }
    }
}



- (void)dealloc
{
    [self stopObserving];
}

@end

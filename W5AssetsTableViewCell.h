//
//  W5AssetsTableViewCell.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol W5AssetsTableViewCellDelegate;

@interface W5AssetsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *cellAssetViews;

@property (nonatomic, weak) id <W5AssetsTableViewCellDelegate> delegate;

+ (W5AssetsTableViewCell *)assetsCellWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;

@end

@protocol W5AssetsTableViewCellDelegate <NSObject>

- (void)assetsTableViewCell:(W5AssetsTableViewCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;

@end
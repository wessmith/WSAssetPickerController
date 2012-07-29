//
//  WSAssetsTableViewCell.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSAssetsTableViewCellDelegate;

@interface WSAssetsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *cellAssetViews;

@property (nonatomic, weak) id <WSAssetsTableViewCellDelegate> delegate;

+ (WSAssetsTableViewCell *)assetsCellWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;

@end

@protocol WSAssetsTableViewCellDelegate <NSObject>

- (void)assetsTableViewCell:(WSAssetsTableViewCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;

@end
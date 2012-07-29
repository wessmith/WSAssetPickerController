//
//  WSAssetTableViewController.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSAssetPickerState;

@interface WSAssetTableViewController : UITableViewController

@property (nonatomic, weak) WSAssetPickerState *assetPickerState;
@property (nonatomic, weak) ALAssetsGroup *assetsGroup; // Model (a specific, filtered, group of assets).

@end

//
//  W5AssetTableViewController.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class W5AssetPickerState;

@interface W5AssetTableViewController : UITableViewController

@property (nonatomic, weak) W5AssetPickerState *assetPickerState;
@property (nonatomic, weak) ALAssetsGroup *assetsGroup; // Model (a specific, filtered, group of assets).

@end

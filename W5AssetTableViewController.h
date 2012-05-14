//
//  W5AssetTableViewController.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface W5AssetTableViewController : UITableViewController

@property (nonatomic, weak) ALAssetsGroup *assetsGroup; // Model (a specific, filtered, group of assets).

@end

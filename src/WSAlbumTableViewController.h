//
//  WSAlbumTableViewController.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSAssetPickerState;

@interface WSAlbumTableViewController : UITableViewController
@property (nonatomic, weak) WSAssetPickerState *assetPickerState;
@end

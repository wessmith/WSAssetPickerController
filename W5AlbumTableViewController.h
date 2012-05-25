//
//  W5AlbumTableViewController.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class W5AssetPickerState;

@interface W5AlbumTableViewController : UITableViewController
@property (nonatomic, weak) W5AssetPickerState *assetPickerState;
@end

//
//  W5AssetPickerController.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetPickerController.h"
#import "W5AlbumTableViewController.h"


@implementation W5AssetPickerController

#pragma mark - Initialization

- (id)initWithDelegate:(id <W5AssetPickerControllerDelegate>)delegate;
{
    // Create the Album TableView Controller.
    W5AlbumTableViewController *albumTableViewController = [[W5AlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    if ((self = [super initWithRootViewController:albumTableViewController])) {
        
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        self.delegate = delegate;
    }

    return self;
}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

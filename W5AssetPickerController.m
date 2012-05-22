//
//  W5AssetPickerController.m
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "W5AssetPickerController.h"
#import "W5AlbumTableViewController.h"

@interface W5AssetPickerController ()
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;
@end


@implementation W5AssetPickerController

@synthesize originalStatusBarStyle = _originalStatusBarStyle;


#pragma mark - Initialization

- (id)initWithDelegate:(id <W5AssetPickerControllerDelegate>)delegate;
{
    // Create the Album TableView Controller.
    W5AlbumTableViewController *albumTableViewController = [[W5AlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    if ((self = [super initWithRootViewController:albumTableViewController])) {
        
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        self.delegate = delegate;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    DLog(@"Toolbar items: %@", self.toolbarItems);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle animated:YES];
}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

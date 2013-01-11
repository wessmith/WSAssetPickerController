//
//  WSViewController.m
//  Toolbar Demo
//
//  Created by Wesley Smith on 1/10/13.
//  Copyright (c) 2013 Wesley D. Smith. All rights reserved.
//

#import "WSViewController.h"
#import "WSPickerWithToolbar.h"

@interface WSViewController () <WSAssetPickerControllerDelegate>
@property (nonatomic, strong) WSPickerWithToolbar *pickerController;
@end

@implementation WSViewController

- (IBAction)pick:(id)sender
{
    self.pickerController = [[WSPickerWithToolbar alloc] initWithDelegate:self];
    
    [self presentViewController:self.pickerController animated:YES completion:NULL];
}

#pragma mark - Picker Delegate Methods

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [sender dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end

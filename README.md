## Description

This is an iOS, Objective-C alternative to `UIImagePickerController` that looks almost exactly the same, but provides the ability to select multiple images. It's as easy to setup as `UIImagePickerController` and it works in both portrait and landscape orientations. It requires the addition of **AssetsLibrary.framework**. This code uses **ARC**.

*Note: Using AssetsLibrary.framework will prompt users to grant access to their photos.*

## Adding to your project

The easiest way to add `WSAssetPickerController` to your project is via CocoaPods:

`pod 'WSAssetPickerController'`

Alternatively you could copy all the files in the `src` directory into your project. Be sure 'Copy items to destination group's folder' is checked.

## Use

1. Import the header using `#import "WSAssetPicker.h"`
2. Create an instance of `WSAssetPickerController` passing an instance of `ALAssetsLibrary`
3. Implement the `WSAssetPickerControllerDelegate` protocol and set the picker's delegate
4. Present the `WSAssetPickerController` instance
5. You will also need to include the selection state `png` files: `WSAssetViewSelectionIndicator.png` and `WSAssetViewSelectionIndicator@2x.png` or make your own.

Check out the demo project for more details.

####Initialization and presentation
```` objective-c

ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
self.assetsLibrary = library;

WSAssetPickerController *controller = [[WSAssetPickerController alloc] initWithAssetsLibrary:library];
[self presentViewController:controller animated:YES completion:NULL];
````

To control the order of assets within the album, use ascendingOrder property.
```` objective-c
// This will list assets in an ascending order in the same way as Photos app does. The
// view is scrolled to the bottom of the table.
controller.ascendingOrder = YES;

// This will list assets in descending order. The view stays at the top of the table.
controller.ascendingOrder = NO;
````


#### Delegate Methods
```` objective-c

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    // Dismiss the WSAssetPickerController.
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    // Dismiss the WSAssetPickerController.
    [self dismissViewControllerAnimated:YES completion:^{
        
        // Do something with the assets here.

    }];
}

````

*Note: The `ALAsset` objects in the `assets` array are only valid for the lifetime of the `ALAssetsLibrary` instance they came from.*

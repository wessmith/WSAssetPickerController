//
//  WSMainViewController.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "WSMainViewController.h"
#import "WSAssetPicker.h"
#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface WSMainViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation WSMainViewController

////////////////////////////////////////////////////////////////////////////////
- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        
        _activityView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_activityView];
    }
    return _activityView;
}

////////////////////////////////////////////////////////////////////////////////
- (void)setScrollView:(UIScrollView *)scrollView
{
    scrollView.layer.cornerRadius = 5.f;
    scrollView.layer.borderWidth = 2.f;
    scrollView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _scrollView = scrollView;
}

////////////////////////////////////////////////////////////////////////////////
- (void)setPageControl:(UIPageControl *)pageControl
{
    pageControl.numberOfPages = 0;
    _pageControl = pageControl;
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGPoint scrollViewCenter = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
    CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.scrollView];
    
    self.activityView.center = activityCenter;
}

////////////////////////////////////////////////////////////////////////////////
- (IBAction)pick:(id)sender
{
    WSAssetPickerController *picker = [WSAssetPickerController pickerWithCompletion:^(NSDictionary *info) {
        
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // Show some activity.
        [self.activityView startAnimating];
        
        // Dismiss the modal picker controller and load the images into the scrollView in the completion block.
        // If we try to load the images from the asset representations before dismissing the modal controller,
        // the UI will block and the experience will be degraded. Yet it's equally important that a reference to
        // the ALAssetsLibrary be maintained until we are finished accessing the ALAsset objects owned by the library.
        // Once the library instance is deallocated, the ALAssets will become unavailable. See the README for more info.
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSArray *assets = [info objectForKey:WSAssetPickerSelectedAssets];
            
            if (assets.count == 0) {
                [self.activityView stopAnimating];
                self.pageControl.numberOfPages = 0;
                self.pageControl.hidden = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            
            // ScrollView setup.
            CGSize contentSize = CGSizeZero;
            contentSize.width = self.scrollView.frame.size.width * assets.count;
            contentSize.height = self.scrollView.frame.size.height;
            self.scrollView.contentSize = contentSize;
            
            // PageControl setup.
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = assets.count;
            
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                
                CGRect imageViewFrame;
                imageViewFrame.origin.x = self.scrollView.frame.size.width * idx;
                imageViewFrame.origin.y = 0;
                imageViewFrame.size = self.scrollView.frame.size;
                
                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.frame = imageViewFrame;
                
                [self.scrollView addSubview:imageView];
            }];
            
            [self.activityView stopAnimating];
            
            [self.scrollView flashScrollIndicators];
        }];
        
    } canceled:^{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // Handle errors.
    [picker setPickerFailedBlock:^(NSError *error) {

        NSLog(@"Picker failed with error -> %@", error.localizedDescription);
    }];
    
    // Limit number of selected items.
    picker.selectionLimit = 5;
    
    [self presentViewController:picker animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////
- (IBAction)changePage:(UIPageControl *)sender
{
    CGRect pageFrame = self.scrollView.bounds;
    pageFrame.origin.x = pageFrame.size.width * self.pageControl.currentPage;
    [self.scrollView scrollRectToVisible:pageFrame animated:YES];
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UIScrollViewDelegate Methods

////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Update the pageControl > 50% of the previous/next page is visible.
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end

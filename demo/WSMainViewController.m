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
#import <QuartzCore/QuartzCore.h>
#import "WSAssetPicker.h"
#import "TSMessage.h"

@interface WSMainViewController () <WSAssetPickerControllerDelegate>
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *unlimitedPickButton;
@property (strong, nonatomic) IBOutlet UIButton *limitedPickButton;
@property (nonatomic, readwrite) BOOL pageControlInUse;
@end


@implementation WSMainViewController

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        
        _activityView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView setColor:[UIColor darkGrayColor]];
        [self.view addSubview:_activityView];
    }
    return _activityView;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    scrollView.layer.cornerRadius = 4.f;
    scrollView.layer.borderWidth = 1.f;
    scrollView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    _scrollView = scrollView;
}

- (void)setPageControl:(UIPageControl *)pageControl
{
    pageControl.numberOfPages = 0;
    _pageControl = pageControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    void (^styleButton)(UIButton *) =
    ^(UIButton *button) {
        
        [button setBackgroundColor:[UIColor clearColor]];
        UIImage *image = [UIImage imageNamed:@"WSButtonBackground"];
        UIImage *pressedImage = [UIImage imageNamed:@"WSButtonBackgroundPressed"];
        [button setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(26, 7, 3, 7)] forState:UIControlStateNormal];
        [button setBackgroundImage:[pressedImage resizableImageWithCapInsets:UIEdgeInsetsMake(26, 7, 3, 7)] forState:UIControlStateHighlighted];
    };
    
    styleButton(self.unlimitedPickButton);
    styleButton(self.limitedPickButton);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGPoint scrollViewCenter = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
    CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.scrollView];
    
    self.activityView.center = activityCenter;
}

- (IBAction)pick:(id)sender
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.assetsLibrary = library;
    
    WSAssetPickerController *picker = [[WSAssetPickerController alloc] initWithAssetsLibrary:library];
    picker.delegate = self;
    if ([sender isEqual:self.limitedPickButton])
        picker.selectionLimit = 5;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)changePage:(UIPageControl *)sender
{
    self.pageControlInUse = YES;
    
    CGRect pageFrame = self.scrollView.bounds;
    pageFrame.origin.x = pageFrame.size.width * self.pageControl.currentPage;
    [self.scrollView scrollRectToVisible:pageFrame animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - WSAssetPickerControllerDelegate Methods

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerControllerDidLimitSelection:(WSAssetPickerController *)sender
{
    if ([TSMessage isNotificationActive] == NO) {
        [TSMessage showNotificationInViewController:sender withTitle:@"Selection limit reached." withMessage:nil withType:TSMessageNotificationTypeWarning withDuration:2.0];
    }
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    // Reset the scroll view and page control.
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentSize = CGSizeZero;
    self.pageControl.numberOfPages = 0;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden = YES;
    
    // Show some activity.
    [self.activityView startAnimating];
    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (assets.count == 0) {
            [self.activityView stopAnimating];
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
        
        int index = 0;
        
        for (ALAsset *asset in assets) {
            
            CGFloat padding = 10.0;
            CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
            imageViewFrame.origin.x = self.scrollView.frame.size.width * index + padding;
            
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            imageView.contentMode = UIViewContentModeScaleAspectFit;

            index++;
            
            [self.scrollView addSubview:imageView];
        }
        
        [self.activityView stopAnimating];
        
        [self.scrollView flashScrollIndicators];
    }];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Update the pageControl > 50% of the previous/next page is visible.
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    self.pageControlInUse = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    self.pageControlInUse = NO;
}

@end

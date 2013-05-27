//
//  WSAssetView.m
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

#import "WSAssetViewColumn.h"
#import "WSAssetWrapper.h"

@interface WSAssetViewColumn ()
@property (nonatomic, weak) UIImageView *selectedView;
@property (nonatomic, strong) BOOL (^shouldSelectItem)(NSInteger column);
@end


@implementation WSAssetViewColumn

@synthesize column = _column;
@synthesize selected = _selected;
@synthesize selectedView = _selectedView;


#pragma mark - Initialization

#define ASSET_VIEW_FRAME CGRectMake(0, 0, 75, 75)

+ (WSAssetViewColumn *)assetViewWithImage:(UIImage *)thumbnail
{
    WSAssetViewColumn *assetView = [[WSAssetViewColumn alloc] initWithImage:thumbnail];
    
    return assetView;
}

- (id)initWithImage:(UIImage *)thumbnail
{
    if ((self = [super initWithFrame:ASSET_VIEW_FRAME])) {
        
        // Setup a tap gesture.
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapAction:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        // Add the photo thumbnail.
        UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:ASSET_VIEW_FRAME];
        assetImageView.contentMode = UIViewContentModeScaleToFill;
        assetImageView.image = thumbnail;
        [self addSubview:assetImageView];
    }
    return self;
}

- (void)setShouldSelectItemBlock:(BOOL(^)(NSInteger column))shouldSelectItemBlock
{
    self.shouldSelectItem = shouldSelectItemBlock;
}

#pragma mark - Setters/Getters

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        
        // KVO compliant notifications.
        [self willChangeValueForKey:@"isSelected"];
        _selected = selected;
        [self didChangeValueForKey:@"isSelected"];
        
        // Update the selectedView.
        self.selectedView.hidden = !_selected;
    }
    [self setNeedsDisplay];
}

#define SELECTED_IMAGE @"WSAssetViewSelectionIndicator.png"

- (UIImageView *)selectedView
{
    if (!_selectedView) {
        
        // Lazily create the selectedView.
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SELECTED_IMAGE]];
        imageView.hidden = YES;
        [self addSubview:imageView];
        
        _selectedView = imageView;
    }
    return _selectedView;
}


#pragma mark - Actions

- (void)userDidTapAction:(UITapGestureRecognizer *)sender
{   
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        // Set the selection state.
        BOOL canSelect = YES;
        if (self.shouldSelectItem)
            canSelect = self.shouldSelectItem(self.column);
        
        self.selected = (canSelect && (self.selected == NO));
    }
}

@end

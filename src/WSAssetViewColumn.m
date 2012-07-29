//
//  WSAssetView.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import "WSAssetViewColumn.h"
#import "WSAssetWrapper.h"

@interface WSAssetViewColumn ()
@property (nonatomic, weak) UIImageView *selectedView;
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
    // Tell the delegate.
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        // Set the selection state.
        self.selected = !self.isSelected;
    }
}
@end

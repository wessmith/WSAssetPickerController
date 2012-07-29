//
//  WSAssetView.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAssetViewColumn : UIView

@property (nonatomic) NSUInteger column;
@property (nonatomic, getter=isSelected) BOOL selected;

+ (WSAssetViewColumn *)assetViewWithImage:(UIImage *)thumbnail;

- (id)initWithImage:(UIImage *)thumbnail;

@end
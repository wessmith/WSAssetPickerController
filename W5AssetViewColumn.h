//
//  W5AssetView.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface W5AssetViewColumn : UIView

@property (nonatomic) NSUInteger column;
@property (nonatomic, getter=isSelected) BOOL selected;

+ (W5AssetViewColumn *)assetViewWithImage:(UIImage *)thumbnail;

- (id)initWithImage:(UIImage *)thumbnail;

@end
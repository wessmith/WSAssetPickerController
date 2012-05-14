//
//  W5AssetPickerController.h
//  W5AssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol W5AssetPickerControllerDelegate <NSObject>

@end

@interface W5AssetPickerController : UINavigationController

// Designated initializer.
- (id)initWithDelegate:(id<W5AssetPickerControllerDelegate, UINavigationControllerDelegate>)delegate;

@end

//
//  LFPhotoCell.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandedViewProtocol.h"

//@class ExpandedViewProtocol;

@interface LFPhotoCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger cellNumber;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic,strong)LFExpandedCellViewController* expandedVC;

+ (void)setExpandedViewProtocol:(id<ExpandedViewProtocol>)delegate;

@end

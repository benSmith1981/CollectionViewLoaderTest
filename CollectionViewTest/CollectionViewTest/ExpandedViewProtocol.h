//
//  ExpandedViewProtocol.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFExpandedCellViewController.h"

@protocol ExpandedViewProtocol <NSObject>
-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC;
@end

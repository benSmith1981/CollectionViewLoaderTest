//
//  ViewController.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParsingCompleteProtocol.h"
#import "ExpandedViewProtocol.h"
#import "LFExpandedCellViewController.h"

@interface LFCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,ParsingCompleteProtocol,CloseExpandedViewProtocol>
@property (nonatomic,strong) LFExpandedCellViewController *lfExpanded;
@end

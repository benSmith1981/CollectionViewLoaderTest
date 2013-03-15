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
#import "CloseExpandedViewProtocol.h"

@interface LFCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ParsingCompleteProtocol,CloseExpandedViewProtocol,ExpandedViewProtocol>

/** Array of image urls returned from our JSON parser*/
@property (nonatomic,strong) NSArray* imageURLs;

@end

//
//  ViewController.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParsingCompleteProtocol.h"
@interface LFCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate,ParsingCompleteProtocol>

@end

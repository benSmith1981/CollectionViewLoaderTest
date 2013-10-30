/**
 * LFPhotoCell - This is a custom CollectionViewCell setup so the properties of each cell can be adjusted however. The photos are made to aspect fit to each cell for example and a pinchgesture recogniser is added to the cells so that when the cells are flicked they expanded
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "LFExpandedViewProtocol.h"
#import "LFCollectionViewController.h"
#import "LFExpandedCellViewController.h"

@class LFExpandedCellViewController;

@interface LFPhotoCell : UICollectionViewCell <UIGestureRecognizerDelegate>

/** Number of the collection view cell*/
@property (nonatomic) NSInteger cellNumber;

/** The view controller that is opened up when the cell has been pinched open*/
@property (nonatomic, strong)LFExpandedCellViewController* expandedVC;

/** The image that is displayed in the custom cell*/
@property (nonatomic, strong, readwrite) UIImageView *cellImageView;

/** Access to the collectionVC so we can bring current cell being pinched to the front*/
@property (nonatomic, strong)UICollectionView* collectionVC;

/** Local copy of image urls*/
@property (nonatomic) NSArray *imageURLsLocal;

/** Holds the original frame value for this cell so we can animate back to it*/
@property (nonatomic) CGRect originalFrame;

/**Class method to set the ExpandedViewProtocol meaning we can set our delegate call back more simply
 */ 
+ (void)setExpandedViewProtocol:(id<LFExpandedViewProtocol>)delegate;

@end

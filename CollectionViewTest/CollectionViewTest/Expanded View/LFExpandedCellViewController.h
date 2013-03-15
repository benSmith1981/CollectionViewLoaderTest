//
//  LFExpandedCellViewController.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloseExpandedViewProtocol.h"
#import "LFPhotoCell.h"
@class CloseExpandedViewProtocol;

@interface LFExpandedCellViewController : UIViewController

/** This is the delegate CloseExpandedViewProtocol which is used to call back to the parent view controller and close this view*/
@property (nonatomic,strong)id<CloseExpandedViewProtocol>closeViewDelegate;

/** This is the cell that the photo belongs to, used to get cell number */
@property (nonatomic,strong) LFPhotoCell *currentPhotoCell;

- (id)initWithFrame:(CGRect)frame andWithImagePath:(NSString*)imagePath andImageURLs:(NSArray*)imageURLsParam andCurrentCell:(LFPhotoCell*)photoCell;

/**Called from colleciton view controller to animate the cell appearing in full view
 */
- (void)animateOpening;
@end

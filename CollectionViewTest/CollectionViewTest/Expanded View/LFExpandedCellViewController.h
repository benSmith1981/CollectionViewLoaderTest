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
#import "LFCollectionViewController.h"
@class CloseExpandedViewProtocol;

@interface LFExpandedCellViewController : UIViewController

/** This is the full size image that is displayed on in our expanded view*/
@property (nonatomic,strong) IBOutlet UIImageView *fullsizeImage;

/** This is the cell that the photo belongs to, used to get cell number */
@property (nonatomic,strong) LFPhotoCell *currentPhotoCell;

/** This is the array of image URLS so we can swipe between the images */
@property (nonatomic,strong) NSArray *imageURLS;

/** This is the delegate CloseExpandedViewProtocol which is used to call back to the parent view controller and close this view*/
@property (nonatomic,strong)id<CloseExpandedViewProtocol>closeViewDelegate;

- (id)initWithFrame:(CGRect)frame;

/**Called from colleciton view controller to animate the cell appearing in full view
 */
- (void)animateOpening;
@end

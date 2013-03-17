/**
 * LFExpandedCellViewController - When a cell is flicked (pinch gesture recogniser) or tapped on the LFExpandedCellViewController is created and added opened. This allows us to create a full screen image of the cell. The pinch gesture and swipe gesture recognisers are implemented here to allow the user to swipe between pictures and to close the LFExpandedCellViewController by pinching.
 *
 * Created by Smith, Benjamin Terry on 3/14/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>
#import "LFCloseExpandedViewProtocol.h"
#import "LFPhotoCell.h"
@class CloseExpandedViewProtocol;

@interface LFExpandedCellViewController : UIViewController

/** This is the delegate CloseExpandedViewProtocol which is used to call back to the parent view controller and close this view*/
@property (nonatomic,strong)id<LFCloseExpandedViewProtocol>closeViewDelegate;

/** This is the cell that the photo belongs to, used to get cell number */
@property (nonatomic,strong) LFPhotoCell *currentPhotoCell;

- (id)initWithFrame:(CGRect)frame andWithImagePath:(NSString*)imagePath andImageURLs:(NSArray*)imageURLsParam andCurrentCell:(LFPhotoCell*)photoCell;

/**Called from colleciton view controller to animate the cell appearing in full view
 */
- (void)animateOpening;
@end

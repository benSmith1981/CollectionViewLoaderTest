/**
 * LFExpandedCellViewController - This protocol is implemented by the CollectionViewController so that when the collection view cell is flicked  the colleciton  view cell sends a call back to the Collection View Controller to expand it and animate it open etc.
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class LFPhotoCell;
@class LFExpandedCellViewController;

/** Implement this to expand the image from a custom colleciton view cell, LFPhotoCell, into our View Controller*/
@protocol LFExpandedViewProtocol <NSObject>

/**Called to expand the custom colleciton view cell into the expanded view controller
 @param LFExpandedCellViewController is the expanded view controller that the image from the cell appears larger in
 */
-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC;
@end

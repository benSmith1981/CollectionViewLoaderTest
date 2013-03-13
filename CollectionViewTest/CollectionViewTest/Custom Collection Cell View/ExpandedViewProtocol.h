//
//  ExpandedViewProtocol.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFPhotoCell;
@class LFExpandedCellViewController;

/** Implement this to expand the image from a custom colleciton view cell, LFPhotoCell, into our View Controller*/
@protocol ExpandedViewProtocol <NSObject>
/**Called to expand the custom colleciton view cell into the expanded view controller
 @param LFExpandedCellViewController is the expanded view controller that the image from the cell appears larger in
 @param LFPhotoCell The cell that we are going to expand, necessary to pass through to get the cell number
 */
-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC photoCell:(LFPhotoCell*)cell;
@end

//
//  ExpandedViewProtocol.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFPhotoCell;
//@class LFExpandedCellViewController;
@class LFExpandedScrollView;


/** Implement this to expand the image from a custom colleciton view cell, LFPhotoCell, into our View Controller*/
@protocol ExpandedViewProtocol <NSObject>
/**Called to expand the custom colleciton view cell into the expanded view controller
 @param LFExpandedCellViewController is the expanded view controller that the image from the cell appears larger in
 */
//-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC;
-(void)expandTheImageView:(LFExpandedScrollView*)expandedVC;

@end

//
//  LFExpandedScrollView.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/15/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPhotoCell.h"
@class CloseExpandedViewProtocol;

@interface LFExpandedScrollView : UIViewController <UIScrollViewDelegate>
/** This is the delegate CloseExpandedViewProtocol which is used to call back to the parent view controller and close this view*/
@property (nonatomic,strong)id<CloseExpandedViewProtocol>closeViewDelegate;

- (id)initWithFrame:(CGRect)frame andImageURLs:(NSArray*)imageURLs andCellNumber:(NSInteger)cellNumber andCurrentCell:(LFPhotoCell*)photoCell;

/**Called from colleciton view controller to animate the cell appearing in full view
 */
- (void)animateOpening;
@end

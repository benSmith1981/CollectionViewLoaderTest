//
//  LFExpandedCellViewController.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloseExpandedViewProtocol.h"

@class CloseExpandedViewProtocol;

@interface LFExpandedCellViewController : UIViewController <UIGestureRecognizerDelegate>
/** This is the scroll that image is displayed in if it is too big for view so we can see all of it*/
@property (nonatomic,strong) IBOutlet UIScrollView *imageScrollView;
/** This is the full size image that is displayed on the detail view*/
@property (nonatomic,strong) UIImageView *fullsizeImage;

@property (nonatomic,strong)id<CloseExpandedViewProtocol>closeViewDelegate;

- (IBAction)closeView:(id)sender;

@end

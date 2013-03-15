//
//  LFExpandedScrollView.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/15/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFExpandedScrollView : UIScrollView <UIScrollViewDelegate>
- (id)initWithFrame:(CGRect)frame andImageURLs:(NSArray*)imageURLs andCellNumber:(NSInteger)cellNumber;
@end

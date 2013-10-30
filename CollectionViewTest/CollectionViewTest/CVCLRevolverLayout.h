//
//  MyCollectionViewLayout.h
//  CollectionViewSample
//
//  Created by 沢 辰洋 on 12/11/05.
//  Copyright (c) 2012年 沢 辰洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVCLRevolverLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat cellInterval;

- (id)initWithCellSize:(CGSize)cellSize;
- (id)initWithCellSize:(CGSize)cellSize cellInterval:(CGFloat)cellInterval;

@end

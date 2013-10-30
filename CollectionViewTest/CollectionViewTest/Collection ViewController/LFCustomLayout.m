//
//  LFCustomLayout.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin (UK) on 30/10/2013.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFCustomLayout.h"
@interface LFCustomLayout()
{
    NSMutableDictionary *cellLayoutInfo;
}

@end

@implementation LFCustomLayout
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}
- (void)setup
{
    NSLog(@"");
}


//total size of everything
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(700, 2000);

}

//return an array of attributes , uicolleciton view to specify size etc
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:5];

    [cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                        UICollectionViewLayoutAttributes *attributes,
                                                        BOOL *innerStop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;

}

//returns specific attributes for a specific item
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cellLayoutInfo[indexPath];

}

- (void)prepareLayout
{
    cellLayoutInfo = [NSMutableDictionary dictionary];
    NSInteger sectionCount = [self.collectionView numberOfSections];;
    NSIndexPath *indexPath;
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];;
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForItemAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originX = random()%500;
    CGFloat originY = random()%1800;
    CGFloat h = random()%200;
    CGFloat w = random()%200;
    return CGRectMake(originX, originY, w, h);
}
@end

//
//  LFExpandedScrollView.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/15/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFExpandedScrollView.h"
#import "LFAFNetworkingInterface.h"

@interface LFExpandedScrollView ()
@property(nonatomic)NSInteger cellNumber;
@property(nonatomic,strong)NSArray *imageURLs;
@property (nonatomic, strong) NSMutableDictionary* photoPages;

@end

@implementation LFExpandedScrollView

@synthesize cellNumber = _cellNumber;
@synthesize imageURLs = _imageURLs;
@synthesize photoPages = _photoPages;

- (id)initWithFrame:(CGRect)frame andImageURLs:(NSArray*)imageURLs andCellNumber:(NSInteger)cellNumber
{
    self = [super init];
    if (self) {
        _photoPages = [NSMutableDictionary new];

        _imageURLs = imageURLs;
        
        _cellNumber = cellNumber;
    }
    return self;
}

- (void)loadView
{
    _photoPages = [NSMutableDictionary new];
        
    self.contentSize = CGSizeMake(self.bounds.size.width * _imageURLs.count,
                                  self.frame.size.height);
    self.pagingEnabled = YES;
    self.delegate = self;
    
    [self loadImageAtCellIndex:_cellNumber];
}

-(void)loadImageAtCellIndex:(NSInteger)cellNumber
{
    // Workout article view controllers to create
    _cellNumber = cellNumber;
    
    NSInteger leftArticle = cellNumber - 1;
    NSInteger display = cellNumber;
    NSInteger rightArticle = cellNumber + 1;
    
    [self createPhotoPage:display IsPrimaryPhoto:YES];
    
    if(leftArticle > 0) {
        [self createPhotoPage:leftArticle IsPrimaryPhoto:NO];
    }
    if(rightArticle < _imageURLs.count) {
        [self createPhotoPage:rightArticle IsPrimaryPhoto:NO];
    }
}

-(void)createPhotoPage:(NSInteger)cellID IsPrimaryPhoto:(BOOL)primaryPhoto
{
    NSString* key = [NSString stringWithFormat:@"%i", cellID];
    
    if(![_photoPages objectForKey:key]) {
        
        CGRect bounds = self.bounds;
        bounds.origin.x = cellID * bounds.size.width;

        NSString *imagePath = [[_imageURLs objectAtIndex:cellID] lastPathComponent];
        [_photoPages setObject:[LFAFNetworkingInterface getSavedImageWithName:imagePath] forKey:key];
        UIImage *tempImage = [LFAFNetworkingInterface getSavedImageWithName:imagePath];
        [self addSubview:[[UIImageView alloc]initWithImage:tempImage]];
        
        if(primaryPhoto) {
            [self scrollRectToVisible:bounds animated:NO];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    static NSInteger previousPhoto = 0;
    CGFloat photoWidth = scrollView.frame.size.width;
    float fractionalPhoto = scrollView.contentOffset.x / photoWidth;
    NSInteger photo = lround(fractionalPhoto);
        
    if (previousPhoto != photo) {
        previousPhoto = photo;
        [self loadImageAtCellIndex:photo];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end

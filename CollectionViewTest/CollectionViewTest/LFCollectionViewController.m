//
//  ViewController.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFCollectionViewController.h"
#import "LFPhotoCell.h"
#import "ParsingCompleteProtocol.h"
#import "AFNetworking.h"
#import "MGAFNetworkingInterface.h"
#import "LFExpandedCellViewController.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface LFCollectionViewController ()
@property (nonatomic) NSInteger cellToExpand;
@property (nonatomic,strong) NSArray* imageURLs;
@property (nonatomic,strong) LFPhotoCell *photoCell;
@end

@implementation LFCollectionViewController
@synthesize imageURLs = _imageURLs;
@synthesize photoCell = _photoCell;
@synthesize cellToExpand = _cellToExpand;
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    [self.collectionView registerClass:[LFPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    //turn activity indicator on to show user images are loading
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    //sets this class up to receive delegate call back when JSON is parsed
    [MGAFNetworkingInterface setImageManifestProtocol:self];
    //intialise array to hold image URLS returned from JSON request
    _imageURLs =  [[NSArray alloc]init];
    //sets off AF networking to parse JSON
    [MGAFNetworkingInterface jsonRequestInitialiser];
    [LFPhotoCell setExpandedViewProtocol:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_imageURLs count]) {
        return [_imageURLs count];
    }
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _photoCell  = [cv dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
//    [_photoCell.imageView setImageWithURL:[[NSURL alloc]initWithString:[_imageURLs objectAtIndex:indexPath.item]]
//                         placeholderImage:[UIImage imageNamed:@"loading.png"]];
    //Request MGAFNetworkingInterface to get the images to populate cells
    [MGAFNetworkingInterface requestImageForCell:_photoCell
                                           atRow:(int)indexPath.item
                                   withImageURLS:_imageURLs];
    
    return _photoCell;
}

#pragma mark - View Rotation

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//                                duration:(NSTimeInterval)duration
//{
//    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
//        self.photoLayout.numberOfColumns = 3;
//        
//        // handle insets for iPhone 4 or 5
//        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
//        45.0f : 25.0f;
//        
//        self.photoLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
//        
//    } else {
//        self.photoLayout.numberOfColumns = 2;
//        self.photoLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
//    }
//}

#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
{
    //initialise imageURLS array with list of URLS returned from JSON parser
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    LFPhotoCell *cell = (LFPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    _cellToExpand = indexPath.item;
    [self.collectionView bringSubviewToFront:cell.imageView];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    // TODO: Select Item
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:0.2f animations:^{
//        cell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//    }];
}

-(void)expandTheImageView
{
    LFExpandedCellViewController *lfExpanded = [[LFExpandedCellViewController alloc]initWithNibName:@"LFExpandedCellViewController" bundle:nil];

    //Get image stored in documents directory
    UIImage *tempImage = [MGAFNetworkingInterface getSavedImageWithName:[[_imageURLs objectAtIndex:_cellToExpand] lastPathComponent]];

    UIImageView* imageView = [[UIImageView alloc] initWithImage:tempImage];

    //set image in detail view
    [lfExpanded setFullsizeImage:imageView];

    [UIView animateWithDuration:0.2f delay:0.2f options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        [self.view addSubview:lfExpanded.view];

    } completion:^(BOOL finished) {
        
    }];
}

@end

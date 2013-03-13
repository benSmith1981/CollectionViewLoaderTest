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
#import <QuartzCore/QuartzCore.h>

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface LFCollectionViewController ()
@property (nonatomic) NSInteger cellToExpand;
@property (nonatomic,strong) NSArray* imageURLs;
@end

@implementation LFCollectionViewController
@synthesize imageURLs = _imageURLs;
@synthesize cellToExpand = _cellToExpand;
@synthesize lfExpanded = _lfExpanded;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    LFPhotoCell *photoCell  = [cv dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
//    [_photoCell.imageView setImageWithURL:[[NSURL alloc]initWithString:[_imageURLs objectAtIndex:indexPath.item]]
//                         placeholderImage:[UIImage imageNamed:@"loading.png"]];
    //Request MGAFNetworkingInterface to get the images to populate cells
    photoCell.cellNumber = indexPath.item;

    [MGAFNetworkingInterface requestImageForCell:photoCell
                                           atRow:(int)indexPath.item
                                   withImageURLS:_imageURLs];
    
    return photoCell;
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
    return CGSizeMake(150, 150);
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
    cell.cellNumber = indexPath.item;
    
    [UIView animateWithDuration:0.2f animations:^{
        
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    // TODO: Select Item
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:0.2f animations:^{
//        cell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    LFPhotoCell *cell = (LFPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.cellNumber = indexPath.item;
//    [self.collectionView bringSubviewToFront:cell.imageView];
    return YES;
}

#pragma mark - ExpandedViewProtocol, expands the view from the collection view cell

-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC photoCell:(LFPhotoCell*)cell
{
    _lfExpanded = expandedVC;

    [self.lfExpanded setCloseViewDelegate:self];

    //Get image stored in documents directory
    UIImage *tempImage = [MGAFNetworkingInterface getSavedImageWithName:[[_imageURLs objectAtIndex:cell.cellNumber] lastPathComponent]];

    UIImageView* imageView = [[UIImageView alloc] initWithImage:tempImage];

    //set image in detail view
    [_lfExpanded setFullsizeImage:imageView];

    _lfExpanded.view.alpha = 0;
    
    [UIView animateWithDuration:1
                     animations:^{
                         _lfExpanded.view.alpha = 1;
                         [self.view addSubview:_lfExpanded.view];
                     }
                     completion:^(BOOL fin){
                         if (fin) {
                             [cell setExpandedVC:nil];
                         }
                     }];
}

#pragma mark - CloseExpandedViewProtocol, closes the expanded view

-(void)expandedViewControlledClosed
{
    [UIView animateWithDuration:1
                     animations:^{
                         _lfExpanded.view.alpha = 0;

                     }
                     completion:^(BOOL fin){
                         [_lfExpanded.view removeFromSuperview];
                         [_lfExpanded removeFromParentViewController];
                         _lfExpanded = nil;
                     }];

}


@end

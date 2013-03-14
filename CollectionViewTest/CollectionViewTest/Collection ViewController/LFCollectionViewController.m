//
//  ViewController.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFCollectionViewController.h"
#import "LFPhotoCell.h"
#import "AFNetworking.h"
#import "LFAFNetworkingInterface.h"
#import "LFConstants.h"
#import "LFExpandedCellViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface LFCollectionViewController ()
/** Array of image urls returned from our JSON parser*/
@property (nonatomic,strong) NSArray* imageURLs;

/** The collection view cell, we have a local copy so that we can reset the expanded view inside of it */
@property (nonatomic,strong) LFPhotoCell* photoCell;

/** Leap Frog (lf) expanded view that we need reference to so as to close it*/
@property (nonatomic,strong) LFExpandedCellViewController *lfExpanded;
@end

@implementation LFCollectionViewController
@synthesize imageURLs = _imageURLs;
@synthesize lfExpanded = _lfExpanded;
@synthesize photoCell = _photoCell;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[LFPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    //turn activity indicator on to show user images are loading
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    //sets this class up to receive delegate call back when JSON is parsed
    [LFAFNetworkingInterface setImageManifestProtocol:self];
    //intialise array to hold image URLS returned from JSON request
    _imageURLs =  [[NSArray alloc]init];
    //sets off AF networking to parse JSON
    [LFAFNetworkingInterface jsonRequestInitialiser];
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

    //Set the custom cells cell number
    photoCell.cellNumber = indexPath.item;
    
    //Let custom cell have access to this collection view so a cell can be brought to front when pinched
    photoCell.collectionVC = self;
    
//    [photoCell.cellImageView setImageWithURL:[[NSURL alloc]initWithString:[_imageURLs objectAtIndex:indexPath.item]]
//                            placeholderImage:[UIImage imageNamed:@"loading.png"]];
    //Request LFAFNetworkingInterface to get the images to populate cells
    [LFAFNetworkingInterface requestImageForCell:photoCell
                                           atRow:(int)indexPath.item
                                   withImageURLS:_imageURLs];
    
    return photoCell;
}

#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
{
    //initialise imageURLS array with list of URLS returned from JSON parser
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    [self.collectionView reloadData];
}

#pragma mark Collection View Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth , cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return minimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return minimumLineitemSpacing;
}

#pragma mark - ExpandedViewProtocol, expands the view from the collection view cell

-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC photoCell:(LFPhotoCell*)cell
{
 
    //Set the _lfExpanded to match that of this current view
    //_lfExpanded.view.frame = self.view.frame;//CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height);

    // set instance variables so view can be removed in expandedViewControlledClosed, and the _expandedVC created inside cell can also be set to nil
    _lfExpanded = expandedVC;
    _photoCell = cell;

    //set the instance variables inside of _lfExpanded so has acccess to the cell and the imageURLs array so we can swipe between photos
    _lfExpanded.currentPhotoCell = cell;
    _lfExpanded.imageURLS = _imageURLs;
    
    //Set delegate call back of expanded VC so that the parent class can close it
    [self.lfExpanded setCloseViewDelegate:self];

    //Get image stored in documents directory
    UIImage *tempImage = [LFAFNetworkingInterface getSavedImageWithName:[[_imageURLs objectAtIndex:cell.cellNumber] lastPathComponent]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:tempImage];
    //set image in detail view
    [_lfExpanded setFullsizeImage:imageView];

    //set alpha to zero so we can animate view into view
    _lfExpanded.view.alpha = 0;
    
    [UIView animateWithDuration:1
                     animations:^{
                         _lfExpanded.view.alpha = 1;
                         //Open expanded view
                         [self.view addSubview:_lfExpanded.view];
                         //[self presentViewController:_lfExpanded animated:YES completion:nil];
                     }
                     completion:^(BOOL finished){

                     }];
}

#pragma mark - CloseExpandedViewProtocol, closes the expanded view

-(void)expandedViewControlledClosed
{
    _lfExpanded.view.alpha = 1;

    [UIView animateWithDuration:1/9
                     animations:^{
                         //animate view out of view to alpha 0
                         _lfExpanded.view.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         //Remove the _lfExpanded view and set to nil
                         [_lfExpanded.view removeFromSuperview];
//                         [_lfExpanded removeFromParentViewController];
//                         _lfExpanded = nil;
                         //set the expanded VC in the photo cell instance to nil, we do this here so that only after view has been opened and then closed is it reset, this stops multiple views being opened when we are pinching the collection view cell
                         [_photoCell setExpandedVC:nil];
                     }];

}


@end

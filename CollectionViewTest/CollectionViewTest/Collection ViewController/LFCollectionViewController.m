/**
 * LFCollectionViewController - This class is the view controller the collection view and lays out the LFPhotoCells (custom UICollectionViewCells)
 * conforming the collection view delegates. It also triggers the data layer (through LFAFNetworkingInterface class) to start download of the JSON
 * and images to display, then confoms to the ParsingCompleteProtocol that sends back a dictionary of URLs for the images, which are then
 * subsequently requested to from the LFAFNetworkingInterface and displayed in each cell through CollectionViewDelegate method
 * collectionView:cellForItemAtIndexPath:
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import "LFCollectionViewController.h"
#import "LFPhotoCell.h"
#import "AFNetworking.h"
#import "LFAFNetworkingInterface.h"
#import "LFConstants.h"
#import "LFExpandedCellViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LFCustomLayout.h"
#import "CVCLRevolverLayout.h"
#import "CVCLCoverFlowLayout.h"
#import "CVCLHomeIconLayout.h"
#import "CVCLStickyHeaderFlowLayout.h"


static NSString * const PhotoCellIdentifier = @"LFPhotoCell";

@interface LFCollectionViewController ()
{
    UICollectionViewLayout *customLayout;
    NSArray *layouts;
    int layoutCounter;

}
/** The collection view cell, we have a local copy so that we can reset the expanded view inside of it */
@property (nonatomic,strong) LFPhotoCell* photoCell;

/** Leap Frog (lf) expanded view that we need reference to so as to close it*/
@property (nonatomic,strong) LFExpandedCellViewController *lfExpanded;
@end

@implementation LFCollectionViewController
@synthesize imageURLs = _imageURLs;
@synthesize lfExpanded = _lfExpanded;
@synthesize photoCell = _photoCell;
@synthesize LFCollectionView = _LFCollectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    layoutCounter = 0;
    layouts = [[NSArray alloc]initWithObjects:[[CVCLRevolverLayout alloc] init],[[CVCLHomeIconLayout alloc] init],[[CVCLCoverFlowLayout alloc] init],[[UICollectionViewFlowLayout alloc] init],nil];
    
    //Register the cell with collection view
    [_LFCollectionView registerClass:[LFPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    //sets this class up to receive delegate call back when JSON is parsed
    [LFAFNetworkingInterface setImageManifestProtocol:self];
    
    //intialise array to hold image URLS returned from JSON request
    _imageURLs =  [[NSArray alloc]init];
    
    //sets this up as delegate for expanded view to call back on
    [LFPhotoCell setExpandedViewProtocol:self];
    
    //turn activity indicator on to show user images are loading
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    
    //sets off AF networking to parse JSON
    [LFAFNetworkingInterface jsonRequestInitialiser];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_imageURLs count]) {
        return [_imageURLs count];
    }
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFPhotoCell *photoCell  = [cv dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    
    //Set the custom cells cell number
    photoCell.cellNumber = indexPath.item;
    
    //Let custom cell have access to this collection view so a cell can be brought to front when pinched
    photoCell.collectionVC = _LFCollectionView;

    //set image urls
    photoCell.imageURLsLocal = _imageURLs;
        
    //Request LFAFNetworkingInterface to get the images to populate cells
    [LFAFNetworkingInterface requestImageForCell:photoCell
                                           atRow:(int)indexPath.item
                                   withImageURLS:_imageURLs];
    
    return photoCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LFPhotoCell *photoCell  = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    
    //set the photo cells number for access later by the expanded view
    photoCell.cellNumber = indexPath.item;

    //Only open one cell at a time incase someone taps multiple cells
    if (!_lfExpanded) {
        _lfExpanded = [[LFExpandedCellViewController alloc]initWithFrame:photoCell.frame
                                                        andWithImagePath:[[_imageURLs objectAtIndex:photoCell.cellNumber] lastPathComponent]andImageURLs:_imageURLs
                                                          andCurrentCell:photoCell];
        
        //Set delegate call back of expanded VC so that the parent class can close it
        [self.lfExpanded setCloseViewDelegate:self];
        
        //add hidden expanded view
        [self.view addSubview:_lfExpanded.view];
        
        //then animate expanded view into view from cell position
        [_lfExpanded animateOpening];
    }
}

#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs; {
    //initialise imageURLS array with list of URLS returned from JSON parser
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    
    [_LFCollectionView reloadData];
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

-(void)expandTheImageView:(LFExpandedCellViewController*)expandedVC {
    // set instance variables so view can be removed in expandedViewControlledClosed, and the _expandedVC created inside cell can also be set to nil
    _lfExpanded = expandedVC;
    
    //Set delegate call back of expanded VC so that the parent class can close it
    [self.lfExpanded setCloseViewDelegate:self];
    
    //add expanded view (set to hidden at first)
    [self.view addSubview:_lfExpanded.view];
    
    //Animate expanded view into view
    [_lfExpanded animateOpening];
}

#pragma mark - CloseExpandedViewProtocol, closes the expanded view and sets to nil

-(void)expandedViewControlledClosed {
    //clear up the expanded view
    [_lfExpanded.view removeFromSuperview];
    [_lfExpanded removeFromParentViewController];
    [_lfExpanded.currentPhotoCell setExpandedVC:nil];
    _lfExpanded = nil;
}

- (IBAction)changeLayout:(id)sender {
    
    if (layoutCounter >= [ layouts count]) {
        layoutCounter = 0;
    }
    customLayout = [layouts objectAtIndex:layoutCounter];
    [_LFCollectionView setCollectionViewLayout:customLayout animated:YES];
    layoutCounter++;
    // scroll to the first visible cell
    if ( 0 < self.LFCollectionView.indexPathsForVisibleItems.count ) {
        NSIndexPath *firstVisibleIdx = [[self.LFCollectionView indexPathsForVisibleItems] objectAtIndex:0];
        [self.LFCollectionView scrollToItemAtIndexPath:firstVisibleIdx atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
}
@end

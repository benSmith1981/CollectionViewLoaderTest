//
//  ViewController.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFCollectionViewController.h"
#import "LFPhotoLayout.h"
#import "LFPhotoCell.h"
#import "ParsingCompleteProtocol.h"
#import "AFNetworking.h"
#import "MGAFNetworkingInterface.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface LFCollectionViewController ()
@property (nonatomic, weak) IBOutlet LFPhotoLayout *photoLayout;
@property (nonatomic,strong) NSArray* imageURLs;

@end

@implementation LFCollectionViewController
@synthesize imageURLs = _imageURLs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    [self.collectionView registerClass:[LFPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    //turn activity indicator on to show user images are loading
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    //sets this class up to receive delegate call back when JSON is parsed
    [MGAFNetworkingInterface setImageManifestProtocol:self];
    //intialise array to hold image URLS returned from JSON request
    _imageURLs =  [[NSArray alloc]init];
    //sets off AF networking to parse JSON
    [MGAFNetworkingInterface jsonRequestInitialiser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_imageURLs count]) {
        return [_imageURLs count];
    }
    else
        return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFPhotoCell *photoCell  = [cv dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    [photoCell.imageView setImageWithURL:[[NSURL alloc]initWithString:[_imageURLs objectAtIndex:indexPath.section]]
                placeholderImage:[UIImage imageNamed:@"loading.png"]];
    
    return photoCell;
}

#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.photoLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoLayout.numberOfColumns = 2;
        self.photoLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

#pragma mark ImageParsingComplete Protocol method
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
{
    //initialise imageURLS array with list of URLS returned from JSON parser
    _imageURLs = [[NSArray alloc]initWithArray:imageURLs];
    [self.collectionView reloadData];
}
@end

/**
 *LFCollectionViewController - This class is the view controller the collection view and lays out the LFPhotoCells (custom UICollectionViewCells) 
 * conforming the collection view delegates. It also triggers the data layer (through LFAFNetworkingInterface class) to start download of the JSON 
 * and images to display, then confoms to the ParsingCompleteProtocol that sends back a dictionary of URLs for the images, which are then 
 * subsequently requested to from the LFAFNetworkingInterface and displayed in each cell through CollectionViewDelegate method 
 * collectionView:cellForItemAtIndexPath:
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "LFParsingCompleteProtocol.h"
#import "LFExpandedViewProtocol.h"
#import "LFCloseExpandedViewProtocol.h"
#import "LFCustomLayout.h"

@interface LFCollectionViewController : UIViewController <UIGestureRecognizerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,LFParsingCompleteProtocol,LFCloseExpandedViewProtocol,LFExpandedViewProtocol>
- (IBAction)changeLayout:(id)sender;

/** Array of image urls returned from our JSON parser*/
@property (nonatomic,strong) NSArray* imageURLs;
@property (weak, nonatomic) IBOutlet UICollectionView *LFCollectionView;

@end

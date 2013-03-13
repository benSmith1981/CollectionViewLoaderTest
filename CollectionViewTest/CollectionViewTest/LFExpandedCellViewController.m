//
//  LFExpandedCellViewController.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFExpandedCellViewController.h"
#import "LFAFNetworkingInterface.h"

@interface LFExpandedCellViewController () <UIGestureRecognizerDelegate>
/** private instance variable to hold the last scale factor so we know what to scale the view to*/
@property (nonatomic) CGFloat lastScale;
/** Used to keep track of the current cell number that we are viewing so we can swipe to the next one in the imageURLs list*/
@property (nonatomic) NSInteger currentCellNumber;

/**Action method called by the pinch gesture recogniser that Scales the views size, when scale reaches certain value the view closes
 */
-(void)scale:(id)sender;

/**Creates the pinch gesture recognisers for this view
 */
-(void)createPinchRecogniserForView;

/**Creates the swipe gesture recognisers for this view
 */
-(void)createSwipeGestureRecognisersForView;

/** Action method called by the swipe gesture recogniser when a left swipe takes place, in this case we are going one image to the right in the collection cell view
 */
-(void)myLeftAction;

/** Action method called by the swipe gesture recogniser when a right swipe takes place, in this case we are going one image to the left in the collection cell view
 */
-(void)myRightAction;
@end

@implementation LFExpandedCellViewController
@synthesize fullsizeImage = _fullsizeImage;
@synthesize lastScale = _lastScale;
@synthesize closeViewDelegate = _closeViewDelegate;
@synthesize currentPhotoCell = _currentPhotoCell;
@synthesize imageURLS = _imageURLS;
@synthesize currentCellNumber = _currentCellNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fullsizeImage setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    self.fullsizeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.fullsizeImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _currentCellNumber = _currentPhotoCell.cellNumber;
    [self createPinchRecogniserForView];
    [self createSwipeGestureRecognisersForView];

    [self.view addSubview:_fullsizeImage];
    [self.view bringSubviewToFront:_fullsizeImage];

    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view setAlpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSwipeGestureRecognisersForView{
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view  addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer * recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftAction)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view  addGestureRecognizer:recognizer2];
}

-(void)createPinchRecogniserForView{
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
}

-(void)scale:(id)sender{
    CGFloat scale;
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = self.view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.view setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    NSLog(@"[(UIPinchGestureRecognizer*)sender scale]: %f",[(UIPinchGestureRecognizer*)sender scale]);
    
    if([(UIPinchGestureRecognizer*)sender scale] < 0.8)
    {
        if (self) {
            [_closeViewDelegate expandedViewControlledClosed];
        }
    }
}

-(void)myRightAction
{
    if ((_currentCellNumber-1) < 0) {
        _currentCellNumber = [_imageURLS count];
    }
    _currentCellNumber -=1;
    NSLog(@"Cell NUmber %i",_currentPhotoCell.cellNumber);
    _fullsizeImage.image = [LFAFNetworkingInterface getSavedImageWithName:[[_imageURLS objectAtIndex:_currentCellNumber] lastPathComponent]];
    [self.view setNeedsDisplay];
}

-(void)myLeftAction
{
    if ((_currentCellNumber+1) >= [_imageURLS count]) {
        _currentCellNumber = 0;
    }
    _currentCellNumber +=1;

    _fullsizeImage.image = [LFAFNetworkingInterface getSavedImageWithName:[[_imageURLS objectAtIndex:_currentCellNumber] lastPathComponent]];
    [self.view setNeedsDisplay];

}

@end

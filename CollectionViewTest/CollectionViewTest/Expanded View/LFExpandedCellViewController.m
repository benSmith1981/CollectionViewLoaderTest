//
//  LFExpandedCellViewController.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFExpandedCellViewController.h"
#import "LFAFNetworkingInterface.h"
#import "AFNetworking.h"

@interface LFExpandedCellViewController () <UIGestureRecognizerDelegate>
/** private instance variable to hold the last scale factor so we know what to scale the view to*/
@property (nonatomic) CGFloat lastScale;

/** Used to keep track of the current cell number that we are viewing so we can swipe to the next one in the imageURLs list*/
@property (nonatomic) NSInteger currentCellNumber;

/** Has the closed animation been called, use a BOOL here as the closed animation can get called mutliple times as it is called from the scale method that is triggered by pinching*/
@property (nonatomic)BOOL closedAnimationHasBeenCalled;

/** This is the full size image that is displayed on in our expanded view*/
@property (nonatomic,strong) IBOutlet UIImageView *fullsizeImage;

/** This is the array of image URLS so we can swipe between the images */
@property (nonatomic,strong) NSArray *imageURLS;

/**
 Action method called by the pinch gesture recogniser that Scales the views size, when scale reaches certain value the view closes
 @param id The type of object that calls the scale object
 */
-(void)scale:(id)sender;

/**
 Creates the pinch gesture recognisers for this view
 */
-(void)createPinchRecogniserForView;

/**
 Creates the swipe gesture recognisers for this view
 */
-(void)createSwipeGestureRecognisersForView;

/**
 Action method called by the swipe gesture recogniser when a left swipe takes place, in this case we are going one image to the right in the collection cell view
 */
-(void)myLeftAction;

/**
 Action method called by the swipe gesture recogniser when a right swipe takes place, in this case we are going one image to the left in the collection cell view
 */
-(void)myRightAction;

/**
 Closes the currently opened view, animating it back to the cell position
 */
-(void)closeAnimation;

/**
 Hides or shows all the views on the view, for example before opening animation is complete everything is hidden, afterwards everything is shown
 @param BOOL Do we show or hide everything on our view
 */
- (void)hide:(BOOL)hide;

@end

@implementation LFExpandedCellViewController
@synthesize fullsizeImage = _fullsizeImage;
@synthesize lastScale = _lastScale;
@synthesize closeViewDelegate = _closeViewDelegate;
@synthesize currentPhotoCell = _currentPhotoCell;
@synthesize imageURLS = _imageURLS;
@synthesize currentCellNumber = _currentCellNumber;
@synthesize closedAnimationHasBeenCalled = _closedAnimationHasBeenCalled;

- (id)initWithFrame:(CGRect)frame andWithImagePath:(NSString*)imagePath andImageURLs:(NSArray*)imageURLsParam andCurrentCell:(LFPhotoCell*)photoCell
{
    self = [super initWithNibName:@"LFExpandedCellViewController" bundle:nil];
    if (self) {
        
        //intialise boolean so that the closed animation can still be called (we only want this called once can cause problems if called more than once)
        _closedAnimationHasBeenCalled = NO;
        
        //set frame to that of the value passed in (the collection view cell's frame)
        self.view.frame = frame;
        
        //Set local imageURLs array from parameter
        self.imageURLS = imageURLsParam;
        
        //set local LFPhotoCell instance so we know what cell we are dealing with
        self.currentPhotoCell = photoCell;
        
        //Call LFAFNetworkingInterface to get image from documents directory
        self.fullsizeImage.image = [LFAFNetworkingInterface getSavedImageWithName:imagePath];
        
        //set the fullsizeImage to aspect fit only
        self.fullsizeImage.contentMode = UIViewContentModeScaleAspectFit;
        
        //set local cell number variable 
        self.currentCellNumber = photoCell.cellNumber;
        
        //Hide everything on view intially
        [self hide:YES];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Set current cell number to that of the cell that has been opened
    //create pinch and swipe gestures on this view so we can close it by pinching, and swipe to next image
    [self createPinchRecogniserForView];
    [self createSwipeGestureRecognisersForView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Create gestures
-(void)createSwipeGestureRecognisersForView
{
    //create first gesture recogniser to view and assign to the myRightAction method when detected
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    //create second gesture recogniser to view and assign to the myLeftAction method when detected
    UISwipeGestureRecognizer * recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftAction)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer2];
}

-(void)createPinchRecogniserForView
{
    //Create pinch gesture recogniser and assign to the scale: method when pinch is detected
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
}

#pragma mark Action for pinch gesture
-(void)scale:(id)sender
{
    CGFloat scale = 0;
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        //set intial scale value
        _lastScale = 1.0;
    }
    //adjust scale value
    scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    //perform transform on view
    CGAffineTransform currentTransform = self.view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.view setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];

    //If you pinch view and it is less that 0.8 scale value then...
    if([(UIPinchGestureRecognizer*)sender scale] < 0.8) {
        //Use this BOOL to make sure only one call to this method is done
        if (!_closedAnimationHasBeenCalled) {
            [self closeAnimation];
        }
    }
}
#pragma mark Actions for swipe gestures
-(void)myRightAction
{
    //check if current cell number -1 is at beginning of images (0 or less)
    if ((_currentCellNumber-1) < 0) {
        //if so set it to max image, go back round
        _currentCellNumber = [_imageURLS count]-1;
    }
    else {
        //take one off current cell number
        _currentCellNumber -=1;
    }
    //Go and get the image from the documents directory that the cell shows, use afnetworking here incase the image we have swiped to hasn't already been downloaded
    [_fullsizeImage setImageWithURL:[[NSURL alloc]initWithString:[_imageURLS objectAtIndex:_currentCellNumber]]
                   placeholderImage:[UIImage imageNamed:@"no_image.png"]];
}

-(void)myLeftAction
{
    //check if current cell number + 1 is at end of images
    if ((_currentCellNumber+1) >= [_imageURLS count])
    {
        //if so reset to beginning
        _currentCellNumber = 0;
    }
    else
    {
        //if not add one to cell number to get next image
        _currentCellNumber +=1;
    }
    //get next image related to this cell number from _imageURLS array, should be stored in documents directory, use afnetworking here incase the image we have swiped to hasn't already been downloaded
    [_fullsizeImage setImageWithURL:[[NSURL alloc]initWithString:[_imageURLS objectAtIndex:_currentCellNumber]]
                   placeholderImage:[UIImage imageNamed:@"no_image.png"]];
}

#pragma mark animate opening and hiding of view
- (void)animateOpening
{
    //Set clear background colour of _fullsizeImage and expanded view, so gives appearance image grows from cell
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_fullsizeImage setBackgroundColor:[UIColor clearColor]];
    
    //as everything on expanded view is hidden unhide _fullsizeImage
    _fullsizeImage.hidden = NO;

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveEaseIn animations:^{
                           //Animate view into position
                           self.view.frame = self.view.superview.bounds;
                           
                           //Fade expanded view black background and other components into view
                           self.view.alpha = 1;
                           [self.view setBackgroundColor:[UIColor blackColor]];

                       }
                    completion:^(BOOL finished) {
                        //unhide all the views
                        [self hide:NO];
                    }];
}

-(void)closeAnimation
{
    //set this so that this method can only get called once
    _closedAnimationHasBeenCalled = YES;

    //Set clear background colour of _fullsizeImage and expanded view, so gives appearance image grows from cell
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_fullsizeImage setBackgroundColor:[UIColor clearColor]];
    
    //Hide everything on the view
    [self hide:YES];
    
    //unhide the image view so we can give make it seem it is moving back into the cells position
    _fullsizeImage.hidden = NO;

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveEaseIn animations:^{
                           //animate the expanded view back to cell it was expanded from!
                           self.view.frame = _currentPhotoCell.originalFrame;
                       }
                        completion:^(BOOL finished) {
                            //call close view delegate to close this expanded view and clean up
                            [_closeViewDelegate expandedViewControlledClosed];
                       }];
}

- (void)hide:(BOOL)hide
{
    //iterate through each view in our view
    for (UIView* view in self.view.subviews) {
        //then set hidden property to whatever the value of the BOOL passed in is
        view.hidden = hide;
    }
}

@end

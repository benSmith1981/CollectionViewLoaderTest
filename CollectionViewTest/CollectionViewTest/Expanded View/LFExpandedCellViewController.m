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

/**Closes the currently opened view, animating it back to the cell position
 */
-(void)closeAnimation;

/**Hides or shows all the views on the view, for example before opening animation is complete everything is hidden, afterwards everything is shown
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

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"LFExpandedCellViewController" bundle:nil];
    if (self) {
        //set frame to that of the value passed in (the collection view cell's frame)
        self.view.frame = frame;
        [self hide:YES];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Set current cell number to that of the cell that has been opened
    _currentCellNumber = _currentPhotoCell.cellNumber;
    //create pinch and swipe gestures on this view so we can close it by pinching, and swipe to next image
    [self createPinchRecogniserForView];
    [self createSwipeGestureRecognisersForView];
    
    //setup autoresizing mask
    [self.fullsizeImage setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    self.fullsizeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.fullsizeImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //add Uiimageview to the view
    [self.view addSubview:_fullsizeImage];
    //set background colour to black
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.fullsizeImage.alpha = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Create gestures
-(void)createSwipeGestureRecognisersForView{
    //create first gesture recogniser to view and assign to the myRightAction method when detected
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    //create second gesture recogniser to view and assign to the myLeftAction method when detected
    UISwipeGestureRecognizer * recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftAction)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer2];
}

-(void)createPinchRecogniserForView{
    //Create pinch gesture recogniser and assign to the scale: method when pinch is detected
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
}

#pragma mark Action for pinch gesture
-(void)scale:(id)sender{
    CGFloat scale;
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
    if([(UIPinchGestureRecognizer*)sender scale] < 0.8)
    {
        //Checks if the view still exists
        if (self)
        {
            [self closeAnimation];
        }
    }
}
#pragma mark Actions for swipe gestures
-(void)myRightAction
{
    //check if current cell number -1 is at beginning of images (0 or less)
    if ((_currentCellNumber-1) < 0)
    {
        //if so set it to max image, go back round
        _currentCellNumber = [_imageURLS count]-1;
    }
    else
    {
        //take one off current cell number
        _currentCellNumber -=1;
    }
    //Go and get the image from the documents directory that the cell shows, use afnetworking here incase the image we have swiped to hasn't already been downloaded
    [_fullsizeImage setImageWithURL:[[NSURL alloc]initWithString:[_imageURLS objectAtIndex:_currentCellNumber]]
                   placeholderImage:nil];
    //refresh the display
    [UIView animateWithDuration:1
                     animations:^{
                         //[self.view setNeedsDisplay];
                     }
                     completion:^(BOOL finished){
                         
                     }];
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
                   placeholderImage:nil];
    //refresh display to show new image
    [UIView animateWithDuration:1
                     animations:^{
                         //[self.view setNeedsDisplay];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

#pragma mark animate opening and hiding of view
- (void)animateOpening
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.view.frame = self.view.superview.bounds;
                     }
                     completion:^(BOOL finished) {
                         [self hide:NO];
                         [self.parentViewController.view bringSubviewToFront:self.view];
                     }];
}

-(void)closeAnimation
{
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionCurveEaseIn animations:^{
                           self.fullsizeImage.frame = _currentPhotoCell.frame;
                       }
                        completion:^(BOOL finished) {
                            [_closeViewDelegate expandedViewControlledClosed];

                       }];
    
//    [UIView animateWithDuration:1.0
//                     animations:^{
//                         self.view.frame = _currentPhotoCell.frame;
//                     }
//                     completion:^(BOOL finished) {
//                         //and closes the view using our CloseExpandedViewProtocol method call back in parent view
//                         [_closeViewDelegate expandedViewControlledClosed];
//                     }];
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

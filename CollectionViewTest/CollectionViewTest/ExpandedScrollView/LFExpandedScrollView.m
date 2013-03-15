//
//  LFExpandedScrollView.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/15/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFExpandedScrollView.h"
#import "LFAFNetworkingInterface.h"

@interface LFExpandedScrollView () <UIGestureRecognizerDelegate>

/** This is the collection cell number that translates to a photo page to load*/
@property(nonatomic)NSInteger cellNumber;

/** This is the array of image URLS so we can swipe between the images */
@property(nonatomic,strong)NSArray *imageURLs;

/** Dictionary of photo pages holds 3 , one either side of page*/
@property (nonatomic, strong) NSMutableDictionary* photoPages;

/** The scroll view we scroll images on*/
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

/** Has the closed animation been called, use a BOOL here as the closed animation can get called mutliple times as it is called from the scale method that is triggered by pinching*/
@property (nonatomic)BOOL closedAnimationHasBeenCalled;

/** This is the cell that the photo belongs to, used to get cell number */
@property (nonatomic,strong) LFPhotoCell *currentPhotoCell;

/** private instance variable to hold the last scale factor so we know what to scale the view to*/
@property (nonatomic) CGFloat lastScale;

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
 Closes the currently opened view, animating it back to the cell position
 */
-(void)closeAnimation;

/**
 Hides or shows all the views on the view, for example before opening animation is complete everything is hidden, afterwards everything is shown
 @param BOOL Do we show or hide everything on our view
 */
- (void)hide:(BOOL)hide;
@end

@implementation LFExpandedScrollView
@synthesize cellNumber = _cellNumber;
@synthesize imageURLs = _imageURLs;
@synthesize photoPages = _photoPages;
@synthesize scrollView = _scrollView;
@synthesize closedAnimationHasBeenCalled = _closedAnimationHasBeenCalled;
@synthesize currentPhotoCell = _currentPhotoCell;
@synthesize lastScale = _lastScale;
@synthesize closeViewDelegate = _closeViewDelegate;

- (id)initWithFrame:(CGRect)frame andImageURLs:(NSArray*)imageURLs andCellNumber:(NSInteger)cellNumber andCurrentCell:(LFPhotoCell*)photoCell
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
    [super loadView];

    _photoPages = [NSMutableDictionary new];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * _imageURLs.count,
                                  _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    [self loadImageAtCellIndex:_cellNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self removeSubArticleViews];
}

-(void)removeSubArticleViews
{
    UIViewController* vc =  [_photoPages objectForKey:[NSString stringWithFormat:@"%i", _cellNumber]];
    
    for (NSString* key in _photoPages) {
        UIViewController* temp = [_photoPages objectForKey:key];
        if(vc != temp) {
            [temp removeFromParentViewController];
            [temp.view removeFromSuperview];
            temp = nil;
        }
    }
    [_photoPages removeAllObjects];
    [_photoPages setObject:vc forKey:[NSString stringWithFormat:@"%i", _cellNumber]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadImageAtCellIndex:_cellNumber];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeSubArticleViews];
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
        
        CGRect bounds = self.view.bounds;
        bounds.origin.x = cellID * bounds.size.width;

        NSString *imagePath = [[_imageURLs objectAtIndex:cellID] lastPathComponent];
        [_photoPages setObject:[LFAFNetworkingInterface getSavedImageWithName:imagePath] forKey:key];
        UIImage *tempImage = [LFAFNetworkingInterface getSavedImageWithName:imagePath];
        [_scrollView addSubview:[[UIImageView alloc]initWithImage:tempImage]];
        
        if(primaryPhoto) {
            [_scrollView scrollRectToVisible:bounds animated:NO];
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

#pragma mark Create gestures

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

#pragma mark animate opening and hiding of view
- (void)animateOpening
{
    //Set clear background colour of _fullsizeImage and expanded view, so gives appearance image grows from cell
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    
    //as everything on expanded view is hidden unhide _fullsizeImage
    _scrollView.hidden = NO;
    
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
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    
    //Hide everything on the view
    [self hide:YES];
    
    //unhide the image view so we can give make it seem it is moving back into the cells position
    _scrollView.hidden = NO;
    
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

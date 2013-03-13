//
//  LFPhotoCell.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFPhotoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LFExpandedCellViewController.h"

/** Created a static ExpandedViewProtocol variable so can be set in the class method call*/
static id<ExpandedViewProtocol>expandedDelegate;

@interface LFPhotoCell ()
/** Private instance variable to hold the last scale factor so we know what to scale the view to*/
@property (nonatomic) CGFloat lastScale;

/** Holds the original scale value so we know what to snap the image back to to fit inside of its cell*/
@property (nonatomic) CGFloat originalScale;

/**Action method called by the pinch gesture recogniser that Scales the views size, when scale reaches certain value the view closes
 */
-(void)scale:(id)sender;

/**Creates the pinch gesture recognisers for this view
 */
-(void)createPinchRecogniserForView;
@end

@implementation LFPhotoCell
@synthesize lastScale = _lastScale;
@synthesize originalScale = _originalScale;
@synthesize expandedVC = _expandedVC;
@synthesize collectionVC = _collectionVC;
@synthesize cellNumber = _cellNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //set our ImageView to be same size as the cell
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        //set its resizing mask to be flexible height and width so it adjusts
        self.cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.cellImageView.backgroundColor = [UIColor underPageBackgroundColor];
        //set imageview to aspect fit inside the cell
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cellImageView.clipsToBounds = YES;
        
        //Create the pinch gesture recogniser for the cell so we can grow it
        [self createPinchRecogniserForView];
        
        //add imageview to the content view
        [self.contentView addSubview:self.cellImageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.cellImageView.image = nil;
}

-(void)createPinchRecogniserForView{
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self addGestureRecognizer:pinchRecognizer];
}

-(void)scale:(id)sender{
    //bring cell to front, above all other cells
    [_collectionVC.view bringSubviewToFront:self];
    CGFloat scale;
    //if we have begun pinching
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        _lastScale = 1.0;
        //get the original scale value so we can snap back to this
        _originalScale = [(UIPinchGestureRecognizer*)sender scale];
    }
    
    //If pinching has finished
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        //The set scale to original value
        scale = _originalScale;
        //Animate transition of cell back to old size
        [UIView animateWithDuration:0.2f animations:^{
            //by creating a transform
            CGAffineTransform newTransform = CGAffineTransformMakeScale(scale, scale);
            //then setting the cell
            [self setTransform:newTransform];
        }];
    }
    else //if we haven't finished
    {
        //calculate new scale value according to pinch size
        scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
        //transform and scale the cell
        CGAffineTransform currentTransform = self.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        [self setTransform:newTransform];
        _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    }

    //If we pinch so cell is of a certain size
    if ([(UIPinchGestureRecognizer*)sender scale] >= 2.5)
    {
        //check if expanded view has been created yet
        if (!_expandedVC)
        {
            //if not create it
            _expandedVC = [[LFExpandedCellViewController alloc]init];
            //call back to delegate collection view class with our newly created expanded view and the cells details
            [expandedDelegate expandTheImageView:_expandedVC photoCell:self];
        }
    }
}

+ (void)setExpandedViewProtocol:(id<ExpandedViewProtocol>)delegate
{
    expandedDelegate = delegate;
}

@end

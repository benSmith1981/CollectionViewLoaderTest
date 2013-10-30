/**
 * LFPhotoCell - This is a custom CollectionViewCell setup so the properties of each cell can be adjusted however. The photos are made to aspect fit to each cell for example and a pinchgesture recogniser is added to the cells so that when the cells are flicked they expanded
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import "LFPhotoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LFExpandedCellViewController.h"
#import "LFAFNetworkingInterface.h"
#import "LFConstants.h"

/** Created a static ExpandedViewProtocol variable so can be set in the class method call*/
static id<LFExpandedViewProtocol>expandedDelegate;

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
@synthesize imageURLsLocal = _imageURLsLocal;
@synthesize originalFrame = _originalFrame;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        //save original frame value;
        _originalFrame = self.frame;
        
        //set frame size of cell
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        
        //set its resizing mask to be flexible height and width so it adjusts
        self.cellImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        //set imageview to aspect fit inside the cell
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //Create the pinch gesture recogniser for the cell so we can grow it
        [self createPinchRecogniserForView];

        //add imageview to the content view
        [self.contentView addSubview:self.cellImageView];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cellImageView.image = nil;
}

-(void)createPinchRecogniserForView {
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self addGestureRecognizer:pinchRecognizer];
}

-(void)scale:(id)sender {
    //bring cell to front, above all other cells
    [_collectionVC bringSubviewToFront:self.cellImageView];
    CGFloat scale = 0;
    
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

    //Check to see if pinch scale reaches a certain size then expand the view
    if ([(UIPinchGestureRecognizer*)sender scale] >= 1.5)
    {
        //check if expanded view has been created yet
        if (!_expandedVC)
        {
            //save original frame value;
            _originalFrame = self.frame;
            
            //if not create it
            _expandedVC = [[LFExpandedCellViewController alloc]initWithFrame:self.frame
                                                            andWithImagePath:[[_imageURLsLocal objectAtIndex:_cellNumber] lastPathComponent]
                                                                andImageURLs:_imageURLsLocal
                                                              andCurrentCell:self];
            
            //call back to delegate collection view class with our newly created expanded view and the cells details
            [expandedDelegate expandTheImageView:_expandedVC];
        }
    }
    else //if doesn't reach this size keep scaling it
    {
        //calculate new scale value according to pinch size
        scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
        
        //transform and scale the cell
        CGAffineTransform currentTransform = self.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        [self setTransform:newTransform];
        _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    }

}

+ (void)setExpandedViewProtocol:(id<LFExpandedViewProtocol>)delegate {
    expandedDelegate = delegate;
}

@end

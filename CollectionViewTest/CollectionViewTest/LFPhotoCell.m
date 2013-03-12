//
//  LFPhotoCell.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

static id<ExpandedViewProtocol>expandedDelegate;

@interface LFPhotoCell ()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGFloat originalScale;
-(void)scale:(id)sender;
-(void)createPinchRecogniserForView;
@end

@implementation LFPhotoCell
@synthesize lastScale = _lastScale;
@synthesize originalScale = _originalScale;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.imageView.backgroundColor = [UIColor underPageBackgroundColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self createPinchRecogniserForView];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

-(void)createPinchRecogniserForView{
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self addGestureRecognizer:pinchRecognizer];
}

-(void)scale:(id)sender{
    CGFloat scale;
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
        _originalScale = [(UIPinchGestureRecognizer*)sender scale];
    }
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        scale = _originalScale;
        [UIView animateWithDuration:0.2f animations:^{
            CGAffineTransform newTransform = CGAffineTransformMakeScale(scale, scale);
            [self setTransform:newTransform];
        }];
    }
    else
    {
        scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
        CGAffineTransform currentTransform = self.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        [self setTransform:newTransform];
        _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    }
    NSLog(@"[(UIPinchGestureRecognizer*)sender scale] %f",[(UIPinchGestureRecognizer*)sender scale]);
    if ([(UIPinchGestureRecognizer*)sender scale] >= 2.5) {
        [expandedDelegate expandTheImageView];
    }
}

+ (void)setExpandedViewProtocol:(id<ExpandedViewProtocol>)delegate
{
    expandedDelegate = delegate;
}

@end

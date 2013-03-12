//
//  LFExpandedCellViewController.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFExpandedCellViewController.h"

@interface LFExpandedCellViewController ()
@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGFloat originalScale;
-(void)scale:(id)sender;
-(void)createPinchRecogniserForView;
@end

@implementation LFExpandedCellViewController
@synthesize fullsizeImage = _fullsizeImage;
@synthesize imageScrollView = _imageScrollView;
@synthesize lastScale = _lastScale;
@synthesize originalScale = _originalScale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _fullsizeImage = [[UIImageView alloc] init];
        [self createPinchRecogniserForView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imageScrollView setContentSize:_fullsizeImage.frame.size];
    [_imageScrollView addSubview:_fullsizeImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createPinchRecogniserForView{
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [_fullsizeImage addGestureRecognizer:pinchRecognizer];
}

-(void)scale:(id)sender{
    CGFloat scale;
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
        _originalScale = [(UIPinchGestureRecognizer*)sender scale];
    }
    scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = _fullsizeImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [_fullsizeImage setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    NSLog(@"[(UIPinchGestureRecognizer*)sender scale]: %f",[(UIPinchGestureRecognizer*)sender scale]);
    
    //if([(UIPinchGestureRecognizer*)sender scale] < 0.5)
        //[self.view removeFromSuperview];
}

- (IBAction)closeView:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}
@end

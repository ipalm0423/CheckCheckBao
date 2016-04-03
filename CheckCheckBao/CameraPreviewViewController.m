//
//  CameraPreviewViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "CameraPreviewViewController.h"
#import "CaptureSessionManager.h"
#import <Photos/Photos.h>

@implementation CameraPreviewViewController {
    BaoController *baoController;
    float imagePrice;
}

@synthesize captureManager;
@synthesize calculatorViewController;

-(void) viewDidLoad {
    [super viewDidLoad];
    
    //camera manager
    self.captureManager = [[CaptureSessionManager alloc] init];
    self.captureManager.delegateCaptureSessionManager = self;
    
    //calculator view
    self.calculatorViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Calculator"];
    self.calculatorViewController.delegate = self;
    [self.calculatorViewController addSubviewOnBottom:self.view];
    
    //bao controller
    baoController = [BaoController shareController];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.captureManager startPreviewCapture: self.view];
    [self.view bringSubviewToFront:self.calculatorViewController.view];
    
}



#pragma mark - calculator delegate
-(void)didEndCalculate:(CalculatorViewController *)calculator sum:(float)sum{
    NSLog(@"get sum from calculator: %f", sum);
    [self.captureManager captureStillPicture];
    imagePrice = sum;
}


#pragma mark - capture manager delegate
-(void)didCaptureStillImage:(CaptureSessionManager *)sessionManager imageData:(UIImage *)image{
    NSLog(@"capture image");
    //animte
    [self animationCaptureImage:image];
    
    //save to bao album
    [baoController saveImageToAlbum:image byDate:[NSDate date] price:imagePrice];
    
    //clear price
    [self.calculatorViewController returnNumberToZero];
}


#pragma mark - animation
-(void)animationCaptureImage:(UIImage*)image{
    //animation
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = image;
    
    [self.view addSubview:imageView];
    UIView *snapShot = [self.view snapshotViewAfterScreenUpdates:YES];
    snapShot.frame = self.view.frame;
    [self.view addSubview:snapShot];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        snapShot.alpha = 0.0;
        imageView.alpha = 0.0;
        snapShot.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height, imageView.frame.size.width / 3, imageView.frame.size.height / 3);
        
        
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [snapShot removeFromSuperview];
        
    }];
}




@end

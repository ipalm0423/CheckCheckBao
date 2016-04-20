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
    NSString *note;
    //picker view
    NSURL *pickerURL;
    UIImageView *pickerImageView;
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
    self.calculatorViewController.delegateCalculator = self;
    [self.calculatorViewController addSubviewOnBottom:self.view];
    
    //reset
    [self.calculatorViewController returnNumberToZero];
    note = @"";
    imagePrice = 0;
    
    //bao controller
    baoController = [BaoController shareController];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.captureManager startPreviewCapture: self.view];

    [self.view bringSubviewToFront:self.calculatorViewController.view];
    [self.view bringSubviewToFront:self.buttonLoad];
    [self.view bringSubviewToFront:self.buttonSum];
    [self.view bringSubviewToFront:self.buttonCapture];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
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

-(void)animateRemovePickerImage{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        pickerImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [pickerImageView removeFromSuperview];
        pickerImageView = nil;
        pickerURL = nil;
        
        [self.buttonLoad setTitle:@"load from album" forState:UIControlStateNormal];
    }];
}


#pragma mark - button
- (IBAction)buttonCaptureTouch:(UIButton *)sender {
    NSLog(@"button capture touch");
    if (pickerImageView) {//save it
        //save to bao album
        [baoController saveImageToAlbumByAssetURL:pickerURL date:[NSDate date] price:imagePrice note:note];
        
        //re-set
        [self.calculatorViewController returnNumberToZero];
        note = @"";
        imagePrice = 0;
        
        //animte
        [self animateRemovePickerImage];
        
    }else{//capture by camera
        [self.captureManager captureStillPicture];
    }
    
    
}

- (IBAction)buttonSumTouch:(UIButton *)sender {
    self.tabBarController.selectedIndex = 1;
    
}


- (IBAction)buttonLoadImageTouch:(UIButton *)sender {
    if (pickerImageView) {//have image, remove it
        [self animateRemovePickerImage];
        //re-set
        [self.calculatorViewController returnNumberToZero];
        note = @"";
        imagePrice = 0;
        
    }else{//create picker
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //設定圖片來源為圖庫
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        //以動畫方式顯示圖庫
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }
    
     
}


#pragma mark - calculator delegate
-(void)didChangeCalculatorValue:(float)value{
    NSLog(@"get sum from calculator: %f", value);
    
    imagePrice = value;
}



#pragma mark - capture manager delegate
-(void)didCaptureStillImage:(CaptureSessionManager *)sessionManager imageData:(UIImage *)image{
    NSLog(@"capture image");
    //animte
    [self animationCaptureImage:image];
    
    //save to bao album
    [baoController saveImageToAlbum:image byDate:[NSDate date] price:imagePrice note:note];
    
    //clear price
    [self.calculatorViewController returnNumberToZero];
    note = @"";
    imagePrice = 0;
}


#pragma mark - image picker delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // AND do whatever you want with it, (NSDictionary *)info is fine now
    UIImage *pickImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    pickerImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    pickerImageView.contentMode = UIViewContentModeScaleToFill;
    pickerImageView.image = pickImage;
    
    //set
    [self.view addSubview:pickerImageView];
    pickerURL = imageUrl;
    
    //已動畫方式返回先前畫面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.buttonLoad setTitle:@"remove" forState:UIControlStateNormal];
    
}



@end

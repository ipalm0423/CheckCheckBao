//
//  CameraOverlayViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "CameraOverlayViewController.h"

@interface CameraOverlayViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *captureButton;

@property (strong, nonatomic) IBOutlet UIImageView *snapImageView;

@end

@implementation CameraOverlayViewController {
    
}



-(void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}




- (IBAction)captureButtonTouch:(id)sender {
    self.pickerController.takePicture;
    
}


#pragma mark - camera delegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.cameraImageView.image = chosenImage;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.snapImageView.image = chosenImage;
        
    });
    
    
    [self.pickerController dismissViewControllerAnimated:NO completion:^{
        //complete
        NSLog(@"did capture picture");
    }];
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.pickerController dismissViewControllerAnimated:NO completion:^{
        //
    }];
}

@end

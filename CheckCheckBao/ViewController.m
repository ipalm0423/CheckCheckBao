//
//  ViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property UIImagePickerController *pickController;


@end

@implementation ViewController{
    //UIImagePickerController *pickController;
}


@synthesize pickController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    //self.overlay = [[OverlayViewController alloc] initWithNibName:@"Overlay" bundle:nil];
    //self.overlay.pickerReference = self.picker;
    //self.pickController.cameraOverlayView = self.overlay.view;
    //self.picker.delegate = self.overlay;
    
    
    
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)captureButtonTouch:(id)sender {
    
    
    
    self.pickController = [[UIImagePickerController alloc] init];
    self.pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.pickController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.pickController.showsCameraControls = NO;
    self.pickController.navigationBarHidden = YES;
    self.pickController.toolbarHidden = YES;
    self.pickController.allowsEditing = YES;
    //self.pickController.wantsFullScreenLayout = YES;
    self.pickController.extendedLayoutIncludesOpaqueBars = YES;
    
    // Insert the overlay
    self.pickController.cameraOverlayView = self.view;
    self.pickController.delegate = self;
    [self presentViewController:self.pickController animated:YES completion:^{
        
    }];
}








@end

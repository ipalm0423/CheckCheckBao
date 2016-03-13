//
//  CameraPreviewViewController.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CaptureSessionManager.h"
#import "CalculatorViewController.h"
#import "BaoController.h"

@interface CameraPreviewViewController : UIViewController<CalculatorDelegate, CaptureSessionManagerDelegate>

@property CaptureSessionManager *captureManager;
@property CalculatorViewController *calculatorViewController;


@end

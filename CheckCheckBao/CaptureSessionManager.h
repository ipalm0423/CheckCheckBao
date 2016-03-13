//
//  CaptureSessionManager.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class CaptureSessionManager;

@protocol CaptureSessionManagerDelegate <NSObject>

@required
-(void)didCaptureStillImage:(CaptureSessionManager*)sessionManager imageData:(UIImage*)image;

@end

@interface CaptureSessionManager : NSObject


@property id<CaptureSessionManagerDelegate> delegateCaptureSessionManager;


@property AVCaptureSession *avCaptureSession;
@property AVCaptureVideoPreviewLayer *previewLayer;
@property AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureConnection *videoConnection;

-(void) startPreviewCapture:(UIView*) view;
-(void) captureStillPicture;

@end

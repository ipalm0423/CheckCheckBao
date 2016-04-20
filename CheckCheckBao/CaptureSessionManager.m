//
//  CaptureSessionManager.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "CaptureSessionManager.h"
#import <UIKit/UIKit.h>
@import ImageIO;

@implementation CaptureSessionManager{
    
    
}

@synthesize avCaptureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;


-(id)init {
    if ((self = [super init])) {
        
        self.avCaptureSession = [[AVCaptureSession alloc] init];
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        if (!input) {
            NSLog(@"Couldn't create video capture device");
        }else {
            [avCaptureSession addInput:input];
            self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.avCaptureSession];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            
            //init still image
            self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
            NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
            
            [stillImageOutput setOutputSettings:outputSettings];
            
            [self.stillImageOutput setOutputSettings:outputSettings];
            
            [self.avCaptureSession addOutput:self.stillImageOutput];
        }
    }
    return self;
}

-(void) startPreviewCapture: (UIView *) previewView {
    
    self.previewLayer.frame = previewView.bounds;
    [previewView.layer insertSublayer:self.previewLayer atIndex:0];
    //[previewView.layer addSublayer:self.previewLayer];
    
    [self.avCaptureSession startRunning];
    
}

-(void) captureStillPicture {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                
                
                [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                    
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    if (self.delegateCaptureSessionManager && [self.delegateCaptureSessionManager respondsToSelector:@selector(didCaptureStillImage:imageData:)]) {
                        [self.delegateCaptureSessionManager didCaptureStillImage:self imageData:image];
                        
                        
                    }
                    
                }];
                break;
            }
        }
        //if (videoConnection) { break; }
    }
    
    
}




@end

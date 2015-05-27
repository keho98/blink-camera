//
//  BCMCameraSession.m
//  BlinkCamera
//
//  Created by Kevin Ho on 5/17/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import "BCMCameraSession.h"

@interface BCMCameraSession ()
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, assign) BOOL isDeviceAuthorized;
@end

@implementation BCMCameraSession

- (void)configureNewSession {
    return;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    return previewLayer;
}

@end

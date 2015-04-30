//
//  BCMBlinkDetector.m
//  BlinkCamera
//
//  Created by Kevin Ho on 4/29/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BCMBlinkDetector.h"

@interface BCMBlinkDetector ()
@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation BCMBlinkDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.session = [[AVCaptureSession alloc] init];
        [self configureSession];
    }
    return self;
}

- (void)configureSession
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if ([self.session canAddInput:cameraDeviceInput]) {
        [self.session addInput:cameraDeviceInput];
    }
}

@end


//
//  BCMBlinkDetector.h
//  BlinkCamera
//
//  Created by Kevin Ho on 4/29/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

@import UIKit;
@import AVFoundation;

@interface BCMBlinkDetector : NSObject <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
@property AVCaptureDevice *device;

- (void)record;
- (void)configureNewSession;
- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

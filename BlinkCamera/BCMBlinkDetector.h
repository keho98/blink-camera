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
@property (nonatomic, assign) NSInteger frameCount;

- (void)record;
- (void)configureNewSession;
- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

@protocol BCMBlinkDetectorDelegate
- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
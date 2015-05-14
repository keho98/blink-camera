@import UIKit;
@import AVFoundation;


@protocol BCMBlinkDetectorDelegate;

@interface BCMBlinkDetector : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    BOOL isUsingFrontFacingCamera;
    CIDetector *faceDetector;
}

@property AVCaptureDevice *device;
@property (assign, nonatomic) NSInteger frameCount;
@property (weak, nonatomic) id<BCMBlinkDetectorDelegate>delegate;

- (void)record;
- (void)configureNewSession;
- (AVCaptureVideoPreviewLayer *)previewLayer;


@end

@protocol BCMBlinkDetectorDelegate
- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveBlink:(CIFeature *)blink;
@end
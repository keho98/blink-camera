@import UIKit;
@import AVFoundation;

@interface BCMBlinkDetector : NSObject <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    BOOL isUsingFrontFacingCamera;
    CIDetector *faceDetector;
}

@property AVCaptureDevice *device;
@property (nonatomic, assign) NSInteger frameCount;

- (void)record;
- (void)configureNewSession;
- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

@protocol BCMBlinkDetectorDelegate
- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol BCMBlinkDetectorDelegate;

@interface BCMBlinkDetector : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    BOOL isUsingFrontFacingCamera;
    AVCaptureVideoDataOutput *videoDataOutput;
}

@property (strong, nonatomic) CIDetector *faceDetector;
@property (strong, nonatomic)  AVCaptureDevice *device;
@property (weak, nonatomic) id<BCMBlinkDetectorDelegate>delegate;

- (void)start;
- (void)configureNewSession;
- (void)switchCameras;
- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

@protocol BCMBlinkDetectorDelegate
- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveBlink:(CIFeature *)blink;
- (void)blinkDetectorDidDetectFace:(BCMBlinkDetector *)detector;
- (void)blinkDetectorDidEndDetectingFace:(BCMBlinkDetector *)detector;

@end
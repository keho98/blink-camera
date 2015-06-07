#import <CoreImage/CoreImage.h>

#import "BCMBlinkDetector.h"

@interface BCMBlinkDetector ()

// Session management.
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;

@property (nonatomic, assign) BOOL isDeviceAuthorized;
@property (nonatomic, assign) BOOL isFaceDetected;

@end

static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

@implementation BCMBlinkDetector

-(instancetype)init {
    self = [super init];
    if (self) {
        self.isFaceDetected = NO;
        NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
                                         //YES, CIDetectorTracking, YES, CIDetectorEyeBlink, nil];
        self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
        isUsingFrontFacingCamera = YES;
    }
    return self;
}

- (void)configureNewSession
{
    [self requestPermissions];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("com.kho.BlinkCamera.VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"position", AVCaptureDevicePositionFront];
    
    AVCaptureDevice *device = [[[AVCaptureDevice devices] filteredArrayUsingPredicate:predicate] firstObject];
    NSLog(@"Device: %@", device);
    if (!device) {
        NSLog(@"No device found.");
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if ([self.session canAddInput:cameraDeviceInput]) {
        [self.session addInput:cameraDeviceInput];
    } else if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        NSLog(@"Could not add input");
        return;
    }

    stillImageOutput = [AVCaptureStillImageOutput new];
    [stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:(__bridge void *)(AVCaptureStillImageIsCapturingStillImageContext)];
    if ( [session canAddOutput:stillImageOutput] )
        [session addOutput:stillImageOutput];
    
    videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    [videoDataOutput setSampleBufferDelegate:self queue:self.sessionQueue];
    
    if ([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    }
}

- (void)start {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        [self.session startRunning];
    }];
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    return previewLayer;
}

- (NSString *)filePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)requestPermissions {
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setIsDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"BlinkCamera"
                                            message:@"BlinkCamera doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setIsDeviceAuthorized:NO];
            });
        }
    }];
}

- (void)switchCameras {
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;

    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [self.session inputs]) {
                [self.session removeInput:oldInput];
            }
            [self.session addInput:input];
            [self.session commitConfiguration];
            break;
        }
    }
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (IBAction)takePicture:(id)sender
{
    // Find out the current orientation and tell the still image output.
    AVCaptureConnection *stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1.0];

    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                      if (error) {
                                                          [self displayErrorOnMainQueue:error withMessage:@"Take picture failed"];
                                                      }
                                                      else {
                                                          if (doingFaceDetection) {
                                                              // Got an image.
                                                              CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(imageDataSampleBuffer);
                                                              CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
                                                              CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(NSDictionary *)attachments];
                                                              if (attachments)
                                                                  CFRelease(attachments);

                                                              NSDictionary *imageOptions = nil;
                                                              NSNumber *orientation = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyOrientation, NULL);
                                                              if (orientation) {
                                                                  imageOptions = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
                                                              }

                                                              // when processing an existing frame we want any new frames to be automatically dropped
                                                              // queueing this block to execute on the videoDataOutputQueue serial queue ensures this
                                                              // see the header doc for setSampleBufferDelegate:queue: for more information
                                                              dispatch_sync(videoDataOutputQueue, ^(void) {

                                                                  // get the array of CIFeature instances in the given image with a orientation passed in
                                                                  // the detection will be done based on the orientation but the coordinates in the returned features will
                                                                  // still be based on those of the image.
                                                                  NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
                                                                  CGImageRef srcImage = NULL;
                                                                  OSStatus err = CreateCGImageFromCVPixelBuffer(CMSampleBufferGetImageBuffer(imageDataSampleBuffer), &srcImage);
                                                                  check(!err);
                                                                  
                                                                  CGImageRef cgImageResult = [self newSquareOverlayedImageForFeatures:features 
                                                                                                                            inCGImage:srcImage 
                                                                                                                      withOrientation:curDeviceOrientation 
                                                                                                                          frontFacing:isUsingFrontFacingCamera];
                                                                  if (srcImage)
                                                                      CFRelease(srcImage);
                                                                  
                                                                  CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, 
                                                                                                                              imageDataSampleBuffer, 
                                                                                                                              kCMAttachmentMode_ShouldPropagate);
                                                                  [self writeCGImageToCameraRoll:cgImageResult withMetadata:(id)attachments];
                                                                  if (attachments)
                                                                      CFRelease(attachments);
                                                                  if (cgImageResult)
                                                                      CFRelease(cgImageResult);
                                                                  
                                                              });

                                                          }
                                                          else {
                                                              // trivial simple JPEG case
                                                              NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                              CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, 
                                                                                                                          imageDataSampleBuffer, 
                                                                                                                          kCMAttachmentMode_ShouldPropagate);
                                                              ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                                              [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
                                                                  if (error) {
                                                                      [self displayErrorOnMainQueue:error withMessage:@"Save to camera roll failed"];
                                                                  }
                                                              }];
                                                              
                                                              if (attachments)
                                                                  CFRelease(attachments);
                                                          }
                                                      }
                                                  }
     ];
}

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    if (attachments)
        CFRelease(attachments);
    NSDictionary *imageOptions = nil;
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    int exifOrientation;
    
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };
    
    switch (curDeviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    
    imageOptions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:exifOrientation],
                    CIDetectorImageOrientation,
                    @(YES),
                    CIDetectorEyeBlink,
                    nil];
    
    NSArray *features = [self.faceDetector featuresInImage:ciImage options:imageOptions];
    if ([features count] > 0) {
        for (CIFaceFeature *feature in features) {
            if (feature.leftEyeClosed && feature.rightEyeClosed) {
                [self.delegate blinkDetector:self didReceiveBlink:[[CIFeature alloc] init]];
            }
        }
        [self.delegate blinkDetectorDidDetectFace:self];
    } else {
        [self.delegate blinkDetectorDidEndDetectingFace:self];
    }
}

#pragma mark - State Information

- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

@end


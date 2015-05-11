//
//  BCMBlinkDetector.m
//  BlinkCamera
//
//  Created by Kevin Ho on 4/29/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import "BCMBlinkDetector.h"

@interface BCMBlinkDetector ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) BOOL deviceAuthorized;

@end

@implementation BCMBlinkDetector

- (void)configureNewSession
{
    [self requestPermissions];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
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
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    }
}

- (void)record {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.session startRunning];
    }];
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
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
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"AVCam!"
                                            message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

@end


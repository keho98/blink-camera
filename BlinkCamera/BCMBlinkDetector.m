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

@end

@implementation BCMBlinkDetector

- (void)configureNewSession
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"position", AVCaptureDevicePositionBack];
    
    AVCaptureDevice *device = [[[AVCaptureDevice devices] filteredArrayUsingPredicate:predicate] firstObject];
    NSLog(@"Device: %@", device);
    if (!device) {
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if ([self.session canAddInput:cameraDeviceInput]) {
        [self.session addInput:cameraDeviceInput];
    }
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
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

@end


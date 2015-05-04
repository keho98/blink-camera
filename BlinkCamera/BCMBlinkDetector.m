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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"position", AVCaptureDevicePositionBack];
    
    AVCaptureDevice *device = [[[AVCaptureDevice devices] filteredArrayUsingPredicate:predicate] firstObject];
    if (!device) {
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if ([self.session canAddInput:cameraDeviceInput]) {
        [self.session addInput:cameraDeviceInput];
    }
}

- (void)record {
    [self.session startRunning];
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    return [AVCaptureVideoPreviewLayer layerWithSession:self.session];
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


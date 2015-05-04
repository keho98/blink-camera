//
//  BCMBlinkDetector.h
//  BlinkCamera
//
//  Created by Kevin Ho on 4/29/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BCMBlinkDetector : NSObject <AVCaptureFileOutputRecordingDelegate>
@property AVCaptureDevice *device;

- (void)record;
@end

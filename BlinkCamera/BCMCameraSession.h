//
//  BCMCameraSession.h
//  BlinkCamera
//
//  Created by Kevin Ho on 5/17/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BCMCameraSession : NSObject
- (void)configureNewSession;
- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

//
//  ViewController.h
//  BlinkCamera
//
//  Created by Kevin Ho on 4/24/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCMBlinkDetector.h"
#import "BCMCameraSession.h"

@interface BCMViewController : UIViewController <BCMBlinkDetectorDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *blinkView;
@property (weak, nonatomic) IBOutlet UILabel *frameCountLabel;
@property (strong, nonatomic) BCMBlinkDetector *blinkDetector;
@property (strong, nonatomic) BCMCameraSession *cameraSession;
@property (assign, nonatomic) BOOL blinking;

- (void)takePicture;
@end


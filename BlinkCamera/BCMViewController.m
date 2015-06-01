//
//  ViewController.m
//  BlinkCamera
//
//  Created by Kevin Ho on 4/24/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import "BCMViewController.h"

@interface BCMViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@end

@implementation BCMViewController

#pragma mark - View Controller

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (void) _init {
    _blinkDetector = [[BCMBlinkDetector alloc] init];
    _cameraSession = [[BCMCameraSession alloc] init];

    _faceDetected = NO;
    _blinking = NO;

    self.blinkDetector.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.blinkDetector configureNewSession];
    [self.cameraSession configureNewSession];

    [self.blinkDetector start];
}

- (void)viewDidLayoutSubviews {
    AVCaptureVideoPreviewLayer *previewLayer = [self.blinkDetector previewLayer];
    previewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.blinkView.frame), CGRectGetHeight(self.blinkView.frame));
    
    [self.blinkView.layer insertSublayer:previewLayer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Photo Handling

- (void)takePicture {
    
}

#pragma mark - IBAction

- (IBAction)didTapTakePhotoButton:(id)sender {
    
}

- (IBAction)didTapRecordButton:(id)sender {

}

#pragma mark - <BCMBlinkDetectorDelegate>

- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    return;
}

- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveBlink:(CIFeature *)blink {
    [self takePicture];
    self.blinking = YES;
    return;
}

- (void)blinkDetectorDidDetectFace:(BCMBlinkDetector *)detector {
    self.faceDetected = YES;
}

- (void)blinkDetectorDidEndDetectingFace:(BCMBlinkDetector *)detector {
    self.faceDetected = NO;
}

#pragma mark - Property Setters & Getters

- (void)setBlinking:(BOOL)blinking {
    if (_blinking != blinking) {
        _blinking = blinking;
    }
}

- (void)setFaceDetected:(BOOL)faceDetected {
    if (_faceDetected != faceDetected) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.frameCountLabel.backgroundColor = faceDetected ? [UIColor greenColor] : [UIColor clearColor];
        }];
        _faceDetected = faceDetected;
    }
}

@end

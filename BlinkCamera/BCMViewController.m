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

- (void) _init {
    self.blinkDetector = [[BCMBlinkDetector alloc] init];
    self.cameraSession = [[BCMCameraSession alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.blinkDetector configureNewSession];
    [self.cameraSession configureNewSession];
}

- (void)viewDidLayoutSubviews
{
    AVCaptureVideoPreviewLayer *previewLayer = [self.blinkDetector previewLayer];
    previewLayer.frame = self.blinkView.frame;
    
    [self.blinkView.layer insertSublayer:previewLayer atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - Photo Handling

- (void)takePicture {
    
}

#pragma mark - IBAction

- (IBAction)didTapTakePhotoButton:(id)sender
{
    
}

- (IBAction)didTapRecordButton:(id)sender
{
    [self.blinkDetector record];
}

#pragma mark - <BCMBlinkDetectorDelegate>

- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    self.frameCountLabel.text = [NSString stringWithFormat:@"%zd", detector.frameCount];
    return;
}

- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveBlink:(CIFeature *)blink
{
    [self takePicture];
    [UIView animateKeyframesWithDuration:0.5
                                   delay:0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                                      self.frameCountLabel.backgroundColor = [UIColor blueColor];
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                                      self.frameCountLabel.backgroundColor = [UIColor clearColor];
                                  }];
                              }
                              completion:nil];
    return;
}

@end

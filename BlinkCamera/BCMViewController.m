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
    self.blinkDetector = [[BCMBlinkDetector alloc] init];
    self.cameraSession = [[BCMCameraSession alloc] init];

    self.blinkDetector.delegate = self;
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
    previewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.blinkView.frame), CGRectGetHeight(self.blinkView.frame));
    
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
    return;
}

- (void)blinkDetector:(BCMBlinkDetector *)detector didReceiveBlink:(CIFeature *)blink
{
    [self takePicture];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.blinking = YES;
    }];
    return;
}

#pragma mark - Property Setters & Getters

- (void)setBlinking:(BOOL)blinking
{
    if (_blinking != blinking) {
        if (blinking) {
            self.frameCountLabel.backgroundColor = [UIColor greenColor];
        }
        else {
            self.frameCountLabel.backgroundColor = [UIColor clearColor];
        }
        _blinking = blinking;
    }
}

@end

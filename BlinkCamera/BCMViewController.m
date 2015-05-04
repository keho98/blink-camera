//
//  ViewController.m
//  BlinkCamera
//
//  Created by Kevin Ho on 4/24/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import "BCMViewController.h"
#import "BCMBlinkDetector.h"

@interface BCMViewController ()
@property (weak, nonatomic) IBOutlet UIView *fastttCameraView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) BCMBlinkDetector *blinkDetector;

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
    self.fastCamera = [[FastttCamera alloc] init];
    self.fastCamera.delegate = self;
    self.blinkDetector = [[BCMBlinkDetector alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.fastttCameraView.frame;
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


#pragma mark - IBAction

- (IBAction)didTapTakePhotoButton:(id)sender {
    
}

- (IBAction)didTapRecordButton:(id)sender {
    [self.blinkDetector record];
}

@end

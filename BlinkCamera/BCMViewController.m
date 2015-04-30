//
//  ViewController.m
//  BlinkCamera
//
//  Created by Kevin Ho on 4/24/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import "BCMViewController.h"

@interface BCMViewController ()
@property (weak, nonatomic) IBOutlet UIView *fastttCameraView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@end

@implementation BCMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _fastCamera = [[FastttCamera alloc] init];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.fastttCameraView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapTakePhotoButton:(id)sender {
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

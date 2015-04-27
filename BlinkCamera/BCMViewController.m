//
//  ViewController.m
//  BlinkCamera
//
//  Created by Kevin Ho on 4/24/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import <FastttCamera.h>
#import "BCMViewController.h"

@interface BCMViewController () <FastttCameraDelegate>
@property (nonatomic, strong) FastttCamera *fastCamera;
@end

@implementation BCMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fastCamera = [[FastttCamera alloc] init];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

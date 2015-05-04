//
//  ViewController.h
//  BlinkCamera
//
//  Created by Kevin Ho on 4/24/15.
//  Copyright (c) 2015 Keiho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FastttCamera.h>

@interface BCMViewController : UIViewController <FastttCameraDelegate>
@property (nonatomic, strong) FastttCamera *fastCamera;
@property (weak, nonatomic) IBOutlet UIView *blinkView;

@end


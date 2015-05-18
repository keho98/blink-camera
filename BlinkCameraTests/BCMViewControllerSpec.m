#import "Kiwi.h"
#import "BCMViewController.h"
#import "BCMBlinkDetector.h"
#import <FastttCamera.h>

SPEC_BEGIN(BCMViewControllerSpec)

describe(@"BCMViewController", ^{
    __block BCMViewController *subject;
    beforeEach(^{
        subject = [[BCMViewController alloc] init];
    });
    
    it(@"should not autorotate", ^{
        [[theValue([subject shouldAutorotate]) should] beFalse];
    });
    
    context(@"on load", ^{
        beforeEach(^{
            subject.blinkDetector = [BCMBlinkDetector mock];
            [subject viewDidLoad];
        });
    
        it(@"should configure the blink detector", ^{
            [[subject.blinkDetector should] receive:@selector(configureNewSession)];
        });
    });
    
    context(@"when a face is detected", ^{
        beforeEach(^{
            [subject blinkDetector:nil didReceiveBlink:nil];
        });
        
        it(@"should take a photo", ^{
            [[subject should] receive:@selector(takePicture)];
        });
    });
});

SPEC_END


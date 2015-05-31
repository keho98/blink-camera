#import <Cedar/Cedar.h>
#import "BCMViewController.h"
#import "BCMBlinkDetector.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BCMViewControllerSpec)

describe(@"BCMViewController", ^{
    __block BCMViewController *subject;
    __block BCMBlinkDetector *blinkDetector;
    __block BCMCameraSession *cameraSession;

    beforeEach(^{
        subject = [[BCMViewController alloc] init];
    });

    it(@"should be its blink detector's delegate", ^{
        subject.blinkDetector.delegate should be_same_instance_as(subject);
    });

    it(@"should not be blinking", ^{
        subject.blinking should be_falsy;
    });

    describe(@"on load", ^{
        beforeEach(^{
            blinkDetector = nice_fake_for([BCMBlinkDetector class]);
            cameraSession = nice_fake_for([BCMCameraSession class]);

            subject.blinkDetector = blinkDetector;
            subject.cameraSession = cameraSession;

            spy_on(subject);

            subject.view should_not be_nil;
        });
        
        it(@"should configure a blink detector session", ^{
            subject.blinkDetector should have_received(@selector(configureNewSession));
        });

        it(@"should configure a camera session", ^{
            subject.cameraSession should have_received(@selector(configureNewSession));
        });

        it(@"should start the blink detector session", ^{
            subject.blinkDetector should have_received(@selector(start));
        });

        describe(@"when a blink is received", ^{
            beforeEach(^{
                [subject blinkDetector:blinkDetector didReceiveBlink:nil];
            });

            it(@"should take a photo", ^{
                subject should have_received(@selector(takePicture));
            });

            it(@"should be blinking", ^{
                subject.blinking should be_truthy;
            });
        });
    });
});

SPEC_END

#import "Kiwi.h"
#import "BCMBlinkDetector.h"

SPEC_BEGIN(BCMBlinkDetectorSpec)

describe(@"BCMBlinkDetector", ^{
    context(@"on load", ^{
        __block BCMBlinkDetector *subject;
        beforeEach(^{
            subject = [[BCMBlinkDetector alloc] init];
        });
        
        it(@"The selected device should be a front facing camera", ^{
            [[theValue([subject.device position]) should] equal:theValue(AVCaptureDevicePositionFront)];
        });
    });
});

SPEC_END

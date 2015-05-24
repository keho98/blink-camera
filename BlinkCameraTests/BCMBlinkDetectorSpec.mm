#import <Cedar/Cedar.h>
#import "BCMBlinkDetector.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BCMBlinkDetectorSpec)

describe(@"BCMBlinkDetector", ^{
    __block BCMBlinkDetector *subject;
    __block id<BCMBlinkDetectorDelegate> delegate;

    beforeEach(^{
        subject = [[BCMBlinkDetector alloc] init];
        delegate = nice_fake_for(@protocol(BCMBlinkDetectorDelegate));
        subject.delegate = delegate;
    });

    describe(@"when a buffer frame is received", ^{
        beforeEach(^{
            [subject captureOutput:nil
             didOutputSampleBuffer:nil
                    fromConnection:nil];
        });

        it(@"should increment the frame count", ^{
            subject.frameCount should equal(1);
        });
    });
});

SPEC_END

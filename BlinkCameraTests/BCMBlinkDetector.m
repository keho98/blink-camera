#import "Kiwi.h"
#import "BCMBlinkDetector.h"

SPEC_BEGIN(BCM)

describe(@"BCMViewController", ^{
    context(@"on load", ^{
        __block BCMViewController *subject;
        beforeEach(^{
            subject = [[BCMViewController alloc] init];
        });
        
        it(@"should have a fasttt camera property", ^{
            [[subject.fastCamera shouldNot] beNil];
        });
    });
});

SPEC_END

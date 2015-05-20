#import <Cedar/Cedar.h>
#import "BCMViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BCMViewControllerSpec)

describe(@"BCMViewController", ^{
    __block BCMViewController *subject;

    beforeEach(^{
        subject = [[BCMViewController alloc] init];
    });

    describe(@"on load", ^{

    });

    describe(@"when a blink is received", ^{
        beforeEach(^{
            spy_on(subject);
            [subject blinkDetector:nil didReceiveBlink:nil];
        });
        
        it(@"should take a photo", ^{
            subject should have_received(@selector(takePicture));
        });
    });
});

SPEC_END

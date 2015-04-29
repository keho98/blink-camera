#import "Kiwi.h"
#import "BCMViewController.h"
#import <FastttCamera.h>

SPEC_BEGIN(BCMViewControllerSpec)

describe(@"BCMViewController", ^{
    context(@"on load", ^{
        __block BCMViewController *subject;
        beforeEach(^{
            subject = [[BCMViewController alloc] init];
            [[subject.view shouldNot] beNil];
        });
        
        it(@"should have a fasttt camera property", ^{
            [[subject.fastCamera shouldNot] beNil];
        });
    });
});

SPEC_END


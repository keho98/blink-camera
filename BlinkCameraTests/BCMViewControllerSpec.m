#import "Kiwi.h"
#import "BCMViewController.h"
#import <FastttCamera.h>

SPEC_BEGIN(BCMViewControllerSpec)

describe(@"BCMViewController", ^{
    context(@"on load", ^{
        __block BCMViewController *subject;
        beforeEach(^{
            subject = [[BCMViewController alloc] init];
        });
                
        it(@"should not autorotate", ^{
            [[theValue([subject shouldAutorotate]) should] equal:theValue(NO)];
        });
    });
});

SPEC_END


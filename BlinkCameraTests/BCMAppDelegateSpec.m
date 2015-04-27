#import "Kiwi.h"
#import "BCMAppDelegate.h"
#import "BCMViewController.h"

SPEC_BEGIN(BCMAppDelegateSpec)

describe(@"BCMAppDelegate", ^{
    context(@"on load", ^{
        __block BCMAppDelegate *subject;
        __block UIApplication *sharedApplication;
        beforeEach(^{
            subject = [[BCMAppDelegate alloc] init];
            sharedApplication = [UIApplication sharedApplication];
        });
        
        it(@"should create a root view controller", ^{
           [[subject.window.rootViewController should] beKindOfClass:[BCMViewController class]];
        });
    });
});

SPEC_END

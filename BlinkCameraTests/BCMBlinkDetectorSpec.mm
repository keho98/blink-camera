#import <Cedar/Cedar.h>
#import "BCMBlinkDetector.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BCMBlinkDetectorSpec)

describe(@"BCMBlinkDetector", ^{
    __block BCMBlinkDetector *subject;
    __block id<BCMBlinkDetectorDelegate> delegate;
    __block CIDetector *faceDetector;
    __block CIFaceFeature *faceFeature;

    beforeEach(^{
        subject = [[BCMBlinkDetector alloc] init];
        delegate = nice_fake_for(@protocol(BCMBlinkDetectorDelegate));
        subject.delegate = delegate;
        faceFeature = nice_fake_for([CIFaceFeature class]);
    });

    describe(@"when a face is detected", ^{
        beforeEach(^{
            faceFeature stub_method(@selector(leftEyeClosed)).and_return(NO);
            faceFeature stub_method(@selector(rightEyeClosed)).and_return(NO);

            faceDetector = nice_fake_for([CIDetector class]);
            faceDetector stub_method(@selector(featuresInImage:options:)).and_return(@[faceFeature]);
            subject.faceDetector = faceDetector;

            [subject captureOutput:nil didOutputSampleBuffer:nil fromConnection:nil];
        });

        it(@"should call -blinkDetectorDidDetectFace: on its delegate ", ^{
            delegate should have_received(@selector(blinkDetectorDidDetectFace:));
        });
    });

    describe(@"when a face is not detected", ^{
        beforeEach(^{
            faceDetector = nice_fake_for([CIDetector class]);
            faceDetector stub_method(@selector(featuresInImage:options:)).and_return(@[]);
            subject.faceDetector = faceDetector;

            [subject captureOutput:nil didOutputSampleBuffer:nil fromConnection:nil];
        });

        it(@"should call -blinkDetectorDidEndDetectingFace", ^{
            delegate should have_received(@selector(blinkDetectorDidEndDetectingFace:));
        });
    });
});

SPEC_END

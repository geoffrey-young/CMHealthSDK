#import <Foundation/Foundation.h>
#import <CMHealth/CMHealth.h>
#import <CMHealth/CMHConsentValidator.h>

@interface CMHConsentValidatorTestFactory : NSObject
+ (ORKConsentSignatureResult *)validSignatureResult;
+ (ORKConsentSignature *)validSignature;
@end

@implementation CMHConsentValidatorTestFactory

+ (ORKConsentSignatureResult *)validSignatureResult
{
    ORKConsentSignatureResult *signatureResult = [ORKConsentSignatureResult new];
    signatureResult.consented = YES;
    signatureResult.signature = CMHConsentValidatorTestFactory.validSignature;

    return signatureResult;
}

+ (ORKConsentSignature *)validSignature
{
    return [ORKConsentSignature signatureForPersonWithTitle:nil
                                           dateFormatString:nil
                                                 identifier:@"CMHTestIdentifier"
                                                  givenName:@"John"
                                                 familyName:@"Doe"
                                             signatureImage:[UIImage imageNamed:@"Test-Signature-Image.png"]
                                                 dateString:nil];
}

@end

SpecBegin(CMHealthConsentValidator)

describe(@"CMHConsentValidator", ^{
    it(@"should produce an error for a nil consent task", ^{
        NSError *error = nil;

        ORKConsentSignature *signature = [CMHConsentValidator signatureFromConsentResults:nil error:&error];

        expect(signature).to.beNil();
        expect(error).notTo.beNil();
        expect(error.code).to.equal(CMHErrorUserMissingConsent);
    });

    it(@"should produce an error for a task result with no signature", ^{
        NSError *error = nil;

        ORKTaskResult *taskResult = [[ORKTaskResult alloc] initWithTaskIdentifier:@"CMHTestIdentifier" taskRunUUID:[NSUUID new] outputDirectory:nil];

        ORKConsentSignature *signature = [CMHConsentValidator signatureFromConsentResults:taskResult error:&error];

        expect(signature).to.beNil();
        expect(error).notTo.beNil();
        expect(error.code).to.equal(CMHErrorUserMissingSignature);
    });

    it(@"should produce an error if the user did not consent", ^{
        NSError *error = nil;

        ORKTaskResult *taskResult = [[ORKTaskResult alloc] initWithTaskIdentifier:@"CMHTestIdentifier" taskRunUUID:[NSUUID new] outputDirectory:nil];

        ORKConsentSignatureResult *signatureResult = CMHConsentValidatorTestFactory.validSignatureResult;
        signatureResult.consented = NO;

        taskResult.results = @[signatureResult];

        ORKConsentSignature *signature = [CMHConsentValidator signatureFromConsentResults:taskResult error:&error];

        expect(signature).to.beNil();
        expect(error).notTo.beNil();
        expect(error.code).to.equal(CMHErrorUserDidNotConsent);
    });

    it(@"should produce an error if the family and given name are not included", ^{
        NSError *error = nil;

        ORKTaskResult *taskResult = [[ORKTaskResult alloc] initWithTaskIdentifier:@"CMHTestIdentifier" taskRunUUID:[NSUUID new] outputDirectory:nil];

        ORKConsentSignatureResult *signatureResult = CMHConsentValidatorTestFactory.validSignatureResult;
        signatureResult.signature.familyName = nil;
        signatureResult.signature.givenName = nil;

        taskResult.results = @[signatureResult];

        ORKConsentSignature *signature = [CMHConsentValidator signatureFromConsentResults:taskResult error:&error];

        expect(signature).to.beNil();
        expect(error).notTo.beNil();
        expect(error.code).to.equal(CMHErrorUserDidNotProvideName);
    });

    it(@"should produce an error if the signature image is not included", ^{
        NSError *error = nil;

        ORKTaskResult *taskResult = [[ORKTaskResult alloc] initWithTaskIdentifier:@"CMHTestIdentifier" taskRunUUID:[NSUUID new] outputDirectory:nil];

        ORKConsentSignatureResult *signatureResult = CMHConsentValidatorTestFactory.validSignatureResult;
        signatureResult.signature.signatureImage = nil;

        taskResult.results = @[signatureResult];

        ORKConsentSignature *signature = [CMHConsentValidator signatureFromConsentResults:taskResult error:&error];

        expect(signature).to.beNil();
        expect(error).notTo.beNil();
        expect(error.code).to.equal(CMHErrorUserDidNotSign);
    });
});

SpecEnd

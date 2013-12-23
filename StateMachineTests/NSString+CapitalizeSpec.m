#import "Kiwi.h"
#import "NSString+Capitalize.h"

SPEC_BEGIN(NSStringCapitalizeSpec)
context(@"given a test battery of strings", ^{
    __block NSString *lowercaseString = nil;
    __block NSString *uppercaseString = nil;
    __block NSString *mixedCaseString = nil;
    __block NSString *inverseMixedCaseString = nil;
    beforeEach(^{
        lowercaseString = @"lowercase";
        uppercaseString = @"UPPERCASE";
        mixedCaseString = @"MiXeDcAsE";
        inverseMixedCaseString = @"mIxEdCaSe";
    });
    
    describe(@"initialCapital", ^{
        it(@"should upcase only the first character of each string", ^{
            [[[lowercaseString initialCapital] should] equal: @"Lowercase"];
            [[[uppercaseString initialCapital] should] equal: @"UPPERCASE"];
            [[[mixedCaseString initialCapital] should] equal: @"MiXeDcAsE"];
            [[[inverseMixedCaseString initialCapital] should] equal: @"MIxEdCaSe"];
        });
    });
    
    describe(@"initialLowercase", ^{
        it(@"should downcase only the first character of each string", ^{
            [[[lowercaseString initialLowercase] should] equal: @"lowercase"];
            [[[uppercaseString initialLowercase] should] equal: @"uPPERCASE"];
            [[[mixedCaseString initialLowercase] should] equal: @"miXeDcAsE"];
            [[[inverseMixedCaseString initialLowercase] should] equal: @"mIxEdCaSe"];
        });
    });
});
SPEC_END
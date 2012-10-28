#import "Kiwi.h"
#import "LSEvent.h"
#import "LSTransition.h"

SPEC_BEGIN(LSEventSpec)
__block LSEvent *event = nil;
beforeEach(^{
    event = [[LSEvent alloc] initWithName:@"activate" transitions:nil];
});

it(@"should have the name passed via constructor", ^{
    [[event.name should] equal:@"activate"];
});

describe(@"addTransition:", ^{
    it(@"should contain the specified transition", ^{
        LSEvent *result = [event addTransition:[LSTransition transitionFrom:@"pending" to:@"active"]];
        
        [[result.transitions should] haveCountOf:1];
        [[result.transitions should] contain:[LSTransition transitionFrom:@"pending" to:@"active"]];
    });
    
    context(@"when adding a duplicate transition", ^{
        it(@"should not add it the second time", ^{
            LSEvent *result =[event addTransition:[LSTransition transitionFrom:@"pending" to:@"active"]];
            result = [event addTransition:[LSTransition transitionFrom:@"pending" to:@"active"]];
            
            [[result.transitions should] haveCountOf:1];
            [[result.transitions should] contain:[LSTransition transitionFrom:@"pending" to:@"active"]];
        });
    });
});
SPEC_END
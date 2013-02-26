#import "Kiwi.h"
#import "LSTransition.h"

SPEC_BEGIN(LSTransitionSpec)
__block LSTransition *transition = nil;
beforeEach(^{
    transition = [[LSTransition alloc] initFrom:@"pendingActivation" to:@"active"];
});
it(@"should have a source or 'from' state", ^{
    [[transition.from should] equal:@"pendingActivation"];
});

it(@"should have a final or 'to' state", ^{
    [[transition.to should] equal:@"active"];
});
SPEC_END
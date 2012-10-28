#import "Kiwi.h"
#import "LSTransition.h"

SPEC_BEGIN(LSTransitionSpec)
__block LSTransition *transition = nil;
beforeEach(^{
    transition = [[LSTransition alloc] initFrom:@"pending" to:@"active"];
});
it(@"should have a source or 'from' state", ^{
    [[transition.from should] equal:@"pending"];
});

it(@"should have a final or 'to' state", ^{
    [[transition.to should] equal:@"active"];
});
SPEC_END
#import "Kiwi.h"
#import "LSStateMachine.h"

SPEC_BEGIN(LSStateMachineSpec)
__block LSStateMachine *sm = nil;
beforeEach(^{
    sm = [[LSStateMachine alloc] init];
});
describe(@"initialState", ^{
    it(@"should be nil by default", ^{
        [sm.defaultState shouldBeNil];
    });
    context(@"when setting the default state", ^{
        it(@"should set that state as default", ^{
            sm.defaultState = @"pending";
            
            [[sm.defaultState should] equal:@"pending"]; // Over testing? Probably
        });
        context(@"when the state being set as default does not exist in the state machine", ^{
            it(@"should also add it", ^{
                sm.defaultState = @"pending";
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pending"]]];
            });
        });
        context(@"when the state being set as default is already defined in the state machine", ^{
            beforeEach(^{
                [sm addState:@"pending"];
            });
            it(@"should no read it", ^{
                sm.defaultState = @"pending";
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pending"]]];
            });
        });
    });
});

describe(@"addState", ^{
    it(@"should have no states by default", ^{
        [[sm.states should] equal:[[NSSet alloc] init]];
    });
    
    context(@"after adding one state", ^{
        beforeEach(^{
            [sm addState:@"pending"];
        });
        it(@"should contain that state", ^{
            [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pending"]]];
        });
    });
    
    context(@"after adding two states", ^{
        beforeEach(^{
            [sm addState:@"pending"];
            [sm addState:@"active"];
        });
        it(@"should contain those states", ^{
            [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pending", @"active"]]];
        });
    });
    
    context(@"after adding the same state twice", ^{
        it(@"should raise an exception", ^{
            [sm addState:@"pending"];
            [[theBlock(^{
                [sm addState:@"pending"];
            }) should] raiseWithName:NSInvalidArgumentException reason:@"The state 'pending' is already define in the state machine"];
        });
    });
});

describe(@"addTransition", ^{
    it(@"should have no transitions by default", ^{
        [[sm.transitions should] equal: [[NSSet alloc] init]];
    });
    context(@"given a state machine with the states 'pending' and 'active'", ^{
        beforeEach(^{
            [sm addState:@"pending"];
            [sm addState:@"active"];
        });
        describe(@"after adding a transition from 'pending' to 'active' called activate", ^{
            [sm addTransition:@"activate" from:@"pending" to:@"activate"];
        });

    });
});
SPEC_END
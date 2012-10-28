#import "Kiwi.h"
#import "LSStateMachine.h"

SPEC_BEGIN(LSStateMachineSpec)
__block LSStateMachine *sm = nil;
beforeEach(^{
    sm = [[LSStateMachine alloc] init];
});
describe(@"initialState", ^{
    it(@"should be nil by default", ^{
        [sm.initialState shouldBeNil];
    });
    context(@"when setting the initial state", ^{
        it(@"should set that state as default", ^{
            sm.initialState = @"pending";
            
            [[sm.initialState should] equal:@"pending"]; // Over testing? Probably
        });
        context(@"when the state being set as initial does not exist in the state machine", ^{
            it(@"should also add it", ^{
                sm.initialState = @"pending";
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pending"]]];
            });
        });
        context(@"when the state being set as initial is already defined in the state machine", ^{
            beforeEach(^{
                [sm addState:@"pending"];
            });
            it(@"should no read it", ^{
                sm.initialState = @"pending";
                
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
        context(@"when the SM has no initial state", ^{
            it(@"should contain that state", ^{
                [sm addState:@"pending"];
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pending"]]];
            });
            it(@"should set that state as the initial", ^{
                [sm addState:@"pending"];
                
                [[sm.initialState should] equal:@"pending"];
            });
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
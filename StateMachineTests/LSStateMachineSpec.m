#import "Kiwi.h"
#import "LSStateMachine.h"
#import "LSEvent.h"
#import "LStransition.h"

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
            sm.initialState = @"pendingActivation";
            
            [[sm.initialState should] equal:@"pendingActivation"]; // Over testing? Probably
        });
        context(@"when the state being set as initial does not exist in the state machine", ^{
            it(@"should also add it", ^{
                sm.initialState = @"pendingActivation";
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pendingActivation"]]];
            });
        });
        context(@"when the state being set as initial is already defined in the state machine", ^{
            beforeEach(^{
                [sm addState:@"pendingActivation"];
            });
            it(@"should no read it", ^{
                sm.initialState = @"pendingActivation";
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pendingActivation"]]];
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
                [sm addState:@"pendingActivation"];
                
                [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pendingActivation"]]];
            });
            it(@"should set that state as the initial", ^{
                [sm addState:@"pendingActivation"];
                
                [[sm.initialState should] equal:@"pendingActivation"];
            });
        });
    });
    
    context(@"after adding two states", ^{
        beforeEach(^{
            [sm addState:@"pendingActivation"];
            [sm addState:@"active"];
        });
        it(@"should contain those states", ^{
            [[sm.states should] equal:[[NSSet alloc] initWithArray:@[@"pendingActivation", @"active"]]];
        });
    });
    
    context(@"after adding the same state twice", ^{
        it(@"should have no effect", ^{
            [sm addState:@"pendingActivation"];
            [sm addState:@"pendingActivation"];
            
            [[sm.states should] equal:[NSSet setWithObject:@"pendingActivation"]];
        });
    });
});

describe(@"addTransition", ^{
    it(@"should have no transitions by default", ^{
        [[sm.events should] equal: [[NSSet alloc] init]];
    });
    context(@"given a state machine with the states 'pendingActivation' and 'active'", ^{
        beforeEach(^{
            [sm addState:@"pendingActivation"];
            [sm addState:@"active"];
        });
        describe(@"after adding a transition from 'pendingActivation' to 'active' called activate", ^{
            describe(@"when the SM has no events previously defined", ^{
                it(@"should contain one event", ^{
                    [sm when:@"activate" transitionFrom:@"pendingActivation" to:@"active"];
                    
                    [[sm.events should] haveCountOf:1];
                    NSSet *transitions = [NSSet setWithObject:[LSTransition transitionFrom:@"pendingActivation" to:@"active"]];
                    LSEvent * event = [LSEvent eventWithName:@"activate"
                                                 transitions:transitions];
                    [[sm.events should] contain:event];
                });
            });
        });

    });
});

describe(@"nextStateFrom:forEvent:", ^{
    context(@"given a SM with two states and one transition", ^{
        beforeEach(^{
            [sm addState:@"pendingActivation"];
            [sm addState:@"active"];
            
            [sm when:@"activate" transitionFrom:@"pendingActivation" to:@"active"];
        });
        
        context(@"when asking for the next state of a valid transition", ^{
            it(@"should return the correct state", ^{
                [sm nextStateFrom:@"pendingActivation" forEvent:@"activate"];
            });
        });
    });
});

describe(@"eventWithName:", ^{
    context(@"for a non-defined event", ^{
        it(@"should return nil", ^{
            [[sm eventWithName:@"undefined"] shouldBeNil];
        });
    });
    context(@"for a defined event", ^{
        beforeEach(^{
            [sm addState:@"pendingActivation"];
            [sm addState:@"active"];
            [sm addState:@"suspended"];
            [sm addState:@"terminated"];
            
            [sm when:@"activate" transitionFrom:@"pendingActivation" to:@"active"];
            [sm when:@"suspend" transitionFrom:@"active" to:@"suspended"];
            [sm when:@"unsuspend" transitionFrom:@"suspended" to:@"active"];
            [sm when:@"terminate" transitionFrom:@"active" to:@"terminated"];
            [sm when:@"terminate" transitionFrom:@"suspended" to:@"terminated"];
        });
        it(@"should return that event", ^{
            LSEvent *active = [sm eventWithName:@"activate"];
            [[active.name should] equal:@"activate"];
            [[active.transitions should] equal:[NSSet setWithObject:[LSTransition transitionFrom:@"pendingActivation" to:@"active"]]];
            
            LSEvent *suspend = [sm eventWithName:@"suspend"];
            [[suspend.name should] equal:@"suspend"];
            [[suspend.transitions should] equal:[NSSet setWithObject:[LSTransition transitionFrom:@"active" to:@"suspended"]]];
            
            LSEvent *unsuspend = [sm eventWithName:@"unsuspend"];
            [[unsuspend.name should] equal:@"unsuspend"];
            [[unsuspend.transitions should] equal:[NSSet setWithObject:[LSTransition transitionFrom:@"suspended" to:@"active"]]];
            
            LSEvent *terminate = [sm eventWithName:@"terminate"];
            [[terminate.name should] equal:@"terminate"];
            [[terminate.transitions should] equal:[NSSet setWithObjects:[LSTransition transitionFrom:@"active" to:@"terminated"], [LSTransition transitionFrom:@"suspended" to:@"terminated"], nil]];
        });
    });
});
SPEC_END
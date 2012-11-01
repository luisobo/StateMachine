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

describe(@"addBeforeCallback:", ^{
    context(@"when there are no callbaks", ^{
        it(@"should add one", ^{
            __block BOOL called = NO;
            void(^callback)(id) = ^(id obj){
                called = YES;
            };
            LSEvent *result = [event addBeforeCallback:callback];
            
            [result.beforeCallbacks shouldNotBeNil];
            [[result.beforeCallbacks should] haveCountOf:1];
            [[result.beforeCallbacks should] contain:callback];
            
            void(^beforeCallback)(id) = [result.beforeCallbacks objectAtIndex:0];
            [[callback should] equal:beforeCallback];
            beforeCallback([[NSObject alloc] init]);
            [[theValue(called) should] beYes];
        });
    });
    context(@"when adding a second before callback", ^{
        __block BOOL called1 = NO;
        void(^callback1)(id) = ^(id obj){
            called1 = YES;
        };
        __block BOOL called2 = NO;
        void(^callback2)(id) = ^(id obj){
            called2 = YES;
        };
        beforeEach(^{
            event = [event addBeforeCallback:callback1];
        });
        it(@"should have two before callbacks", ^{
            LSEvent *result = [event addBeforeCallback:callback2];
            
            [result.beforeCallbacks shouldNotBeNil];
            [[result.beforeCallbacks should] haveCountOf:2];
            [[result.beforeCallbacks should] contain:callback1];
            [[result.beforeCallbacks should] contain:callback2];
            
            void(^beforeCallback1)(id) = [result.beforeCallbacks objectAtIndex:0];
            [[callback1 should] equal:beforeCallback1];
            beforeCallback1([[NSObject alloc] init]);
            [[theValue(called1) should] beYes];
            
            void(^beforeCallback2)(id) = [result.beforeCallbacks objectAtIndex:1];
            [[callback2 should] equal:beforeCallback2];
            beforeCallback2([[NSObject alloc] init]);
            [[theValue(called2) should] beYes];
        });
    });
});
SPEC_END
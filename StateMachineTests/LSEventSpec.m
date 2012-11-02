#import "Kiwi.h"
#import "LSEvent.h"
#import "LSTransition.h"

SPEC_BEGIN(LSEventSpec)
__block LSEvent *event = nil;
context(@"given an event with a name, a transition and before and after callbacks", ^{
    __block LSStateMachineTransitionCallback beforeCallback = ^(id object) { };
    __block LSStateMachineTransitionCallback afterCallback = ^(id object) { };
    __block LSTransition *transition = nil;
    beforeEach(^{
        transition = [LSTransition transitionFrom:@"foo" to:@"bar"];
        event = [[LSEvent alloc] initWithName:@"activate"
                                  transitions:[NSSet setWithObject:transition]
                              beforeCallbacks:@[beforeCallback]
                               afterCallbacks:@[afterCallback]];
    });
    it(@"should have the name passed via constructor", ^{
        [[event.name should] equal:@"activate"];
    });
    
    describe(@"addTransition:", ^{
        it(@"should contain the specified transition", ^{
            LSEvent *result = [event addTransition:[LSTransition transitionFrom:@"pending" to:@"active"]];
            
            [[result.transitions should] haveCountOf:2];
            [[result.transitions should] contain:[LSTransition transitionFrom:@"pending" to:@"active"]];
        });
        
        context(@"when adding a duplicate transition", ^{
            it(@"should not add it the second time", ^{
                LSEvent *result =[event addTransition:[LSTransition transitionFrom:@"pending" to:@"active"]];
                result = [event addTransition:[LSTransition transitionFrom:@"pending" to:@"active"]];
                
                [[result.transitions should] haveCountOf:2];
                [[result.transitions should] contain:[LSTransition transitionFrom:@"pending" to:@"active"]];
            });
        });
    });
    
    describe(@"addBeforeCallback:", ^{
        context(@"when there is one callbak", ^{
            it(@"should add the second one", ^{
                __block BOOL called = NO;
                void(^callback)(id) = ^(id obj){
                    called = YES;
                };
                LSEvent *result = [event addBeforeCallback:callback];
                
                [result.beforeCallbacks shouldNotBeNil];
                [[result.beforeCallbacks should] haveCountOf:2];
                [[result.beforeCallbacks should] contain:callback];
                
                void(^beforeCallback)(id) = [result.beforeCallbacks objectAtIndex:1];
                [[callback should] equal:beforeCallback];
                beforeCallback([[NSObject alloc] init]);
                [[theValue(called) should] beYes];
            });
        });
        context(@"when adding a third before callback", ^{
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
            it(@"should have three before callbacks", ^{
                LSEvent *result = [event addBeforeCallback:callback2];
                
                [result.beforeCallbacks shouldNotBeNil];
                [[result.beforeCallbacks should] haveCountOf:3];
                [[result.beforeCallbacks should] contain:callback1];
                [[result.beforeCallbacks should] contain:callback2];
                
                void(^beforeCallback1)(id) = [result.beforeCallbacks objectAtIndex:1];
                [[callback1 should] equal:beforeCallback1];
                beforeCallback1([[NSObject alloc] init]);
                [[theValue(called1) should] beYes];
                
                void(^beforeCallback2)(id) = [result.beforeCallbacks objectAtIndex:2];
                [[callback2 should] equal:beforeCallback2];
                beforeCallback2([[NSObject alloc] init]);
                [[theValue(called2) should] beYes];
            });
        });
    });
    
    describe(@"addAfterCallback:", ^{
        context(@"when there is one callbak", ^{
            it(@"should have two", ^{
                __block BOOL called = NO;
                void(^callback)(id) = ^(id obj){
                    called = YES;
                };
                LSEvent *result = [event addAfterCallback:callback];
                
                [result.afterCallbacks shouldNotBeNil];
                [[result.afterCallbacks should] haveCountOf:2];
                [[result.afterCallbacks should] contain:callback];
                
                void(^afterCallback)(id) = [result.afterCallbacks objectAtIndex:1];
                [[callback should] equal:afterCallback];
                afterCallback([[NSObject alloc] init]);
                [[theValue(called) should] beYes];
            });
        });
        context(@"when adding a third after callback", ^{
            __block BOOL called1 = NO;
            void(^callback1)(id) = ^(id obj){
                called1 = YES;
            };
            __block BOOL called2 = NO;
            void(^callback2)(id) = ^(id obj){
                called2 = YES;
            };
            beforeEach(^{
                event = [event addAfterCallback:callback1];
            });
            it(@"should have three after callbacks", ^{
                LSEvent *result = [event addAfterCallback:callback2];
                
                [result.afterCallbacks shouldNotBeNil];
                [[result.afterCallbacks should] haveCountOf:3];
                [[result.afterCallbacks should] contain:callback1];
                [[result.afterCallbacks should] contain:callback2];
                
                void(^afterCallback1)(id) = [result.afterCallbacks objectAtIndex:1];
                [[callback1 should] equal:afterCallback1];
                afterCallback1([[NSObject alloc] init]);
                [[theValue(called1) should] beYes];
                
                void(^afterCallback2)(id) = [result.afterCallbacks objectAtIndex:2];
                [[callback2 should] equal:afterCallback2];
                afterCallback2([[NSObject alloc] init]);
                [[theValue(called2) should] beYes];
            });
        });
    });
});
SPEC_END
#import "Kiwi.h"
#import "StateMachine.h"

@interface Subscription : NSObject
@property (nonatomic, retain) NSString *state;
@end

@interface Subscription (State)
- (void)initializeStateMachine;
- (BOOL)activate;
- (BOOL)suspend;
- (BOOL)unsuspend;
- (BOOL)terminate;

- (BOOL)isPending;
- (BOOL)isActive;
- (BOOL)isSuspended;
- (BOOL)isTerminated;
@end
@implementation Subscription

STATE_MACHINE(^(LSStateMachine *sm) {
    sm.initialState = @"pending";
    
    [sm addState:@"pending"];
    [sm addState:@"active"];
    [sm addState:@"suspended"];
    [sm addState:@"terminated"];
    
    [sm when:@"activate" transitionFrom:@"pending" to:@"active"];
    [sm when:@"suspend" transitionFrom:@"active" to:@"suspended"];
    [sm when:@"unsuspend" transitionFrom:@"suspended" to:@"active"];
    [sm when:@"terminate" transitionFrom:@"active" to:@"terminated"];
    [sm when:@"terminate" transitionFrom:@"suspended" to:@"terminated"];
});

- (id)init {
    self = [super init];
    if (self) {
        [self initializeStateMachine];
    }
    return self;
}

@end

SPEC_BEGIN(StateMachineSpec)
context(@"given a Subscripion", ^{
    __block Subscription *sut = nil;
    beforeEach(^{
        sut = [[Subscription alloc] init];
    });
    
    describe(@"default state", ^{
        it(@"should be 'pending'", ^{
            [[sut.state should] equal: @"pending"];
        });
    });
    
    describe(@"valid transitions", ^{
        describe(@"activate", ^{
            describe(@"from 'pending'", ^{
                it(@"should change the state to 'active'", ^{
                    [sut activate];
                    
                    [[sut.state should] equal:@"active"];
                });
                it(@"should return YES", ^{
                    [[theValue([sut activate]) should] beYes];
                });
            });
        });
        describe(@"suspend", ^{
            describe(@"from 'active'", ^{
                beforeEach(^{
                    [sut activate];
                });
                it(@"should change the state to 'suspended'", ^{
                    [sut suspend];
                    [[sut.state should] equal:@"suspended"];
                    
                });
                it(@"should return YES", ^{
                    [[theValue([sut suspend]) should] beYes];
                });
            });
        });
        describe(@"unsuspend", ^{
            describe(@"from 'suspended'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should change the state to 'active'", ^{
                    [sut unsuspend];
                    [[sut.state should] equal:@"active"];
                });
                it(@"should return YES", ^{
                    [[theValue([sut unsuspend]) should] beYes];
                });
            });
        });
        describe(@"terminate", ^{
            describe(@"from'active'", ^{
                beforeEach(^{
                    [sut activate];
                });
                it(@"should change the state to 'terminated'", ^{
                    [sut terminate];
                    [[sut.state should] equal:@"terminated"];
                });
                it(@"should return YES", ^{
                    [[theValue([sut terminate]) should] beYes];
                });
            });
            describe(@"from 'suspended'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should change the state to 'terminated'", ^{
                    [sut terminate];
                    [[sut.state should] equal:@"terminated"];
                });
                it(@"should return YES", ^{
                    [[theValue([sut terminate]) should] beYes];
                });
            });
        });
    });
    
    describe(@"invalid transitions", ^{
        describe(@"activate", ^{
            describe(@"from 'suspended", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should return NO", ^{
                    [[theValue([sut activate]) should] beNo];
                });
                it(@"should not change the state", ^{
                    [[sut.state should] equal:@"suspended"];
                });
            });
        });
        describe(@"terminate", ^{
            describe(@"from pending", ^{
                it(@"should return NO", ^{
                    [[theValue([sut terminate]) should] beNo];
                });
                it(@"should not change the state", ^{
                    [[sut.state should] equal:@"pending"];
                });
            });
        });
    });
    
    describe(@"checking if it's in a state", ^{
        describe(@"isPending", ^{
            context(@"when 'pending'", ^{
                it(@"should return YES", ^{
                    [[theValue([sut isPending]) should] beYes];
                });
            });
            context(@"when 'active'", ^{
                beforeEach(^{
                    [sut activate];
                });
                it(@"should return NO", ^{
                    [[theValue([sut isPending]) should] beNo];
                });
            });
            context(@"when 'suspended'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should return NO", ^{
                    [[theValue([sut isPending]) should] beNo];
                });
            });
            context(@"when 'terminated'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut terminate];
                    
                });
                it(@"should return NO", ^{
                    [[theValue([sut isPending]) should] beNo];
                });
            });
        });
        describe(@"isActive", ^{
            context(@"when 'pending'", ^{
                it(@"should return NO", ^{
                    [[theValue([sut isActive]) should] beNo];
                });
            });
            context(@"when 'active'", ^{
                beforeEach(^{
                    [sut activate];
                });
                it(@"should return YES", ^{
                    [[theValue([sut isActive]) should] beYes];
                });
            });
            context(@"when 'suspended'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should return NO", ^{
                    [[theValue([sut isActive]) should] beNo];
                });
            });
            context(@"when 'terminated'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut terminate];
                    
                });
                it(@"should return NO", ^{
                    [[theValue([sut isActive]) should] beNo];
                });
            });
        });
        describe(@"isSuspended", ^{
            context(@"when 'pending'", ^{
                it(@"should return NO", ^{
                    [[theValue([sut isSuspended]) should] beNo];
                });
            });
            context(@"when 'active'", ^{
                beforeEach(^{
                    [sut activate];
                });
                it(@"should return NO", ^{
                    [[theValue([sut isSuspended]) should] beNo];
                });
            });
            context(@"when 'suspended'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should return YES", ^{
                    [[theValue([sut isSuspended]) should] beYes];
                });
            });
            context(@"when 'terminated'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut terminate];
                    
                });
                it(@"should return NO", ^{
                    [[theValue([sut isSuspended]) should] beNo];
                });
            });
        });
        describe(@"isTerminated", ^{
            context(@"when 'pending'", ^{
                it(@"should return NO", ^{
                    [[theValue([sut isTerminated]) should] beNo];
                });
            });
            context(@"when 'active'", ^{
                beforeEach(^{
                    [sut activate];
                });
                it(@"should return NO", ^{
                    [[theValue([sut isTerminated]) should] beNo];
                });
            });
            context(@"when 'suspended'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut suspend];
                });
                it(@"should return NO", ^{
                    [[theValue([sut isTerminated]) should] beNo];
                });
            });
            context(@"when 'terminated'", ^{
                beforeEach(^{
                    [sut activate];
                    [sut terminate];
                    
                });
                it(@"should return YES", ^{
                    [[theValue([sut isTerminated]) should] beYes];
                });
            });
        });
    });
});
SPEC_END
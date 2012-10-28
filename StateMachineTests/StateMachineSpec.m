#import "Kiwi.h"

@interface Subscription : NSObject
@property (nonatomic, retain) NSString *state;
@end
@implementation Subscription
- (id)init {
    self = [super init];
    if (self) {
        _state = @"pending";
    }
    return self;
}

- (void)activate {
    self.state = @"active";
}
- (void)suspend {
    self.state = @"suspended";
}
- (void)terminate {
    if ([@[@"active", @"suspended"] containsObject:self.state]) {
        self.state = @"terminated";
    } else {
        [NSException raise:@"StateMachineInvalidTransition" format:@"A 'Subscription' received a 'terminate' event in the state 'pending', which is an invalid transition"];
    }
}

@end
@interface Subscription (State)
@property (nonatomic, retain, readonly) NSString *state;
- (void)activate;
- (void)suspend;
- (void)terminate;
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
            });
        });
        describe(@"suspend", ^{
            describe(@"from 'active'", ^{
                it(@"should change the state to 'suspended'", ^{
                    [sut activate];
                    
                    [sut suspend];
                    [[sut.state should] equal:@"suspended"];
                    
                });
            });
        });
        describe(@"terminate", ^{
            describe(@"from'active'", ^{
                it(@"should change the state to 'terminated'", ^{
                    [sut activate];
                    
                    [sut terminate];
                    [[sut.state should] equal:@"terminated"];
                });
            });
            describe(@"from 'suspended'", ^{
                it(@"should change the state to 'terminated'", ^{
                    [sut activate];
                    [sut suspend];
                    
                    [sut terminate];
                    [[sut.state should] equal:@"terminated"];
                });
            });
        });
    });
    
    describe(@"invalid transitions", ^{
        describe(@"from 'pending' to 'terminated'", ^{
            it(@"should raise an exception", ^{
                [[theBlock(^{
                    [sut terminate];
                }) should] raiseWithName:@"StateMachineInvalidTransition" reason:@"A 'Subscription' received a 'terminate' event in the state 'pending', which is an invalid transition"];
            });
        });
    });
});
SPEC_END
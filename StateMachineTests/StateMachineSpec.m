#import "Kiwi.h"
#import <objc/runtime.h>
#import "LSStateMachine.h"

@interface Subscription : NSObject
@property (nonatomic, retain) NSString *state;
@end
@implementation Subscription
+ (LSStateMachine *)stateMachine {
    return nil;
}
BOOL activate(id self, SEL _cmd) {
    Subscription *subscription = (Subscription *)self;
    if ([@[@"pending"] containsObject:subscription.state]) {
        subscription.state = @"active";
        return YES;
    } else {
        return NO;
    }
}
+ (void) initialize {
    class_addMethod(self, @selector(activate), (IMP) activate, "v@:");
}
- (id)init {
    self = [super init];
    if (self) {
        _state = @"pending";
    }
    return self;
}

- (BOOL)suspend {
    self.state = @"suspended";
    return YES;
}
- (BOOL)unsuspend {
    self.state = @"active";
    return YES;
}
- (BOOL)terminate {
    if ([@[@"active", @"suspended"] containsObject:self.state]) {
        self.state = @"terminated";
        return YES;
    } else {
        return NO;
    }
}

@end
@interface Subscription (State)
@property (nonatomic, retain, readonly) NSString *state;
- (BOOL)activate;
- (BOOL)suspend;
- (BOOL)unsuspend;
- (BOOL)terminate;
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
            });
        });
        describe(@"terminate", ^{
            describe(@"from pending", ^{
                it(@"should return NO", ^{
                    [[theValue([sut terminate]) should] beNo];
                });
            });
        });


    });
});
SPEC_END
#import "LSStateMachine.h"

@interface LSStateMachine ()
@property (nonatomic, strong) NSMutableSet *mutableStates;
@property (nonatomic, strong) NSMutableSet *mutableTransitions;
@end
@implementation LSStateMachine
- (id)init {
    self = [super init];
    if (self) {
        _mutableStates = [[NSMutableSet alloc] init];
        _mutableTransitions = [[NSMutableSet alloc] init];
    }
    return self;
}
- (void)addState:(NSString *)state {
    if ([self.mutableStates containsObject:state]) {
        [NSException raise:NSInvalidArgumentException format:@"The state '%@' is already define in the state machine", state];
        return;
    }
    [self.mutableStates addObject:state];
}

- (void)addTransition:(NSString *)eventName from:(NSString *)initialState to:(NSString *)finalState {
    
}

- (NSSet *)states {
    return [NSSet setWithSet:self.mutableStates];
}

- (NSSet *)transitions {
    return [NSSet setWithSet:self.mutableTransitions];
}

- (void)setDefaultState:(NSString *)defaultState {
    [self willChangeValueForKey:@"defaultState"];
    _defaultState = defaultState;
    [self.mutableStates addObject:defaultState];
    [self didChangeValueForKey:@"defaulState"];
}
@end

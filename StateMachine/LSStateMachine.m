#import "LSStateMachine.h"
#import "LSEvent.h"
#import "LSTransition.h"

@interface LSStateMachine ()
- (LSEvent *)eventWithName:(NSString *)name;
@end

@interface LSStateMachine ()
@property (nonatomic, strong) NSMutableSet *mutableStates;
@property (nonatomic, strong) NSMutableSet *mutableEvents;
@end
@implementation LSStateMachine
- (id)init {
    self = [super init];
    if (self) {
        _mutableStates = [[NSMutableSet alloc] init];
        _mutableEvents = [[NSMutableSet alloc] init];
    }
    return self;
}
- (void)addState:(NSString *)state {
    if ([self.mutableStates containsObject:state]) {
        [NSException raise:NSInvalidArgumentException format:@"The state '%@' is already define in the state machine", state];
        return;
    }
    [self.mutableStates addObject:state];
    if (!self.initialState) {
        self.initialState = state;
    }
}

- (void)when:(NSString *)eventName transitionFrom:(NSString *)from to:(NSString *)to; {
    LSEvent *event = [self eventWithName:eventName];
    LSTransition *transition = [LSTransition transitionFrom:from to:to];
    if (!event) {
        event = [LSEvent eventWithName:eventName transitions:[NSSet setWithObject:transition]];
    } else {
        [self.mutableEvents removeObject:event];
        event = [event addTransition:transition];
    }
    [self.mutableEvents addObject:event];
}

- (NSSet *)states {
    return [NSSet setWithSet:self.mutableStates];
}

- (NSSet *)events {
    return [NSSet setWithSet:self.mutableEvents];
}

- (void)setInitialState:(NSString *)defaultState {
    [self willChangeValueForKey:@"initialState"];
    _initialState = defaultState;
    [self.mutableStates addObject:defaultState];
    [self didChangeValueForKey:@"defaulState"];
}

#pragma mark - Private Methods

- (LSEvent *)eventWithName:(NSString *)name {
    for (LSEvent *event in self.events) {
        if ([event.name isEqualToString:name])
            return event;
    }
    return nil;
}




@end

#import "LSStateMachine.h"
#import "LSEvent.h"
#import "LSTransition.h"
#import "LSStateMachineTypedefs.h"

void * LSStateMachineDefinitionKey = &LSStateMachineDefinitionKey;

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
    [self.mutableStates addObject:state];
    if (!self.initialState) {
        self.initialState = state;
    }
}

- (void)when:(NSString *)eventName transitionFrom:(NSString *)from to:(NSString *)to; {
    [self when:eventName transitionFrom:from to:to if:nil];
}

- (void)when:(NSString *)eventName transitionFrom:(NSString *)from to:(NSString *)to if:(LSStateMachineTransitionCondition)condition; {
    LSEvent *event = [self eventWithName:eventName];
    LSTransition *transition = [LSTransition transitionFrom:from to:to];
    transition.condition = condition;
    if (!event) {
        event = [LSEvent eventWithName:eventName transitions:[NSSet setWithObject:transition]];
    } else {
        [self.mutableEvents removeObject:event];
        event = [event addTransition:transition];
    }
    [self.mutableEvents addObject:event];
}

- (NSString *)nextStateFrom:(NSString *)from forEvent:(NSString *)eventName {
    LSEvent *event = [self eventWithName:eventName];
    for (LSTransition *transition in event.transitions) {
        if ([transition.from isEqualToString:from] && [transition checkCondition]) {
            return transition.to;
        }
    }
    return nil;
}

- (void)before:(NSString *)eventName do:(LSStateMachineTransitionCallback)callback {
    LSEvent *oldEvent = [self eventWithName:eventName];
    [self.mutableEvents removeObject:oldEvent];
    LSEvent *newEvent = [oldEvent addBeforeCallback:callback];
    [self.mutableEvents addObject:newEvent];
}

- (void)after:(NSString *)eventName do:(LSStateMachineTransitionCallback)callback {
    LSEvent *oldEvent = [self eventWithName:eventName];
    [self.mutableEvents removeObject:oldEvent];
    LSEvent *newEvent = [oldEvent addAfterCallback:callback];
    [self.mutableEvents addObject:newEvent];
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
    [self didChangeValueForKey:@"initialState"];
}

- (LSEvent *)eventWithName:(NSString *)name {
    for (LSEvent *event in self.events) {
        if ([event.name isEqualToString:name])
            return event;
    }
    return nil;
}

@end

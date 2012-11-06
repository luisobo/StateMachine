#import "LSStateMachineDynamicAdditions.h"
#import "LSStateMachine.h"
#import "LSEvent.h"

#import <objc/runtime.h>

extern void * LSStateMachineDefinitionKey;

BOOL LSStateMachineTriggerEvent(id self, SEL _cmd);
void LSStateMachineInitializeInstance(id self, SEL _cmd);

// This is the implementation of all the event instance methods
BOOL LSStateMachineTriggerEvent(id self, SEL _cmd) {
    NSString *currentState = [self performSelector:@selector(state)];
    LSStateMachine *sm = [[self class] performSelector:@selector(stateMachine)];
    NSString *eventName = NSStringFromSelector(_cmd);
    NSString *nextState = [sm nextStateFrom:currentState forEvent:eventName];
    if (nextState) {
        LSEvent *event = [sm eventWithName:eventName];
        NSArray *beforeCallbacks = event.beforeCallbacks;
        for (void(^beforeCallback)(id) in beforeCallbacks) {
            beforeCallback(self);
        }
        [self performSelector:@selector(setState:) withObject:nextState];
        
        NSArray *afterCallbacks = event.afterCallbacks;
        for (LSStateMachineTransitionCallback afterCallback in afterCallbacks) {
            afterCallback(self);
        }
        return YES;
    } else {
        return NO;
    }
}

// This is the implementation of the initializeStateMachine instance method
void LSStateMachineInitializeInstance(id self, SEL _cmd) {
    LSStateMachine *sm = [[self class] performSelector:@selector(stateMachine)];
    [self performSelector:@selector(setState:) withObject:[sm initialState]];
}

// This is the implementation of all the is<StateName> instance methods
BOOL LSStateMachineCheckState(id self, SEL _cmd) {
    NSString *currentState = [self performSelector:@selector(state)];
    NSString *query = [[NSStringFromSelector(_cmd) substringFromIndex:2] lowercaseString];
    return [query isEqualToString:currentState];
}

// This is the implementation of all the can<EventName> instance methods
BOOL LSStateMachineCheckCanTransition(id self, SEL _cmd) {
    LSStateMachine *sm = [[self class] performSelector:@selector(stateMachine)];
    NSString *currentState = [self performSelector:@selector(state)];
    NSString *query = [[NSStringFromSelector(_cmd) substringFromIndex:3] lowercaseString];
    NSString *nextState = [sm nextStateFrom:currentState forEvent:query];
    return nextState != nil;
}

// This is called in the initilize class method in the STATE_MACHINE macro
void LSStateMachineInitializeClass(Class klass) {
    LSStateMachine *sm = [klass performSelector:@selector(stateMachine)];
    for (LSEvent *event in sm.events) {
        class_addMethod(klass, NSSelectorFromString(event.name), (IMP) LSStateMachineTriggerEvent, "i@:");
        
        NSString *transitionQueryMethodName = [NSString stringWithFormat:@"can%@", [event.name capitalizedString]];
        class_addMethod(klass, NSSelectorFromString(transitionQueryMethodName), (IMP) LSStateMachineCheckCanTransition, "i@:");
    }
    
    for (NSString *state in sm.states) {
        NSString *queryMethodName = [NSString stringWithFormat:@"is%@", [state capitalizedString]];
        class_addMethod(klass, NSSelectorFromString(queryMethodName), (IMP) LSStateMachineCheckState, "i@:");
    }
    class_addMethod(klass, @selector(initializeStateMachine), (IMP) LSStateMachineInitializeInstance, "v@:");
}

// This is called in the stateMachine class method defined by the STATE_MACHINE macro
LSStateMachine * LSStateMachineSetDefinitionForClass(Class klass,void(^definition)(LSStateMachine *)) {
    LSStateMachine *sm = (LSStateMachine *)objc_getAssociatedObject(klass, &LSStateMachineDefinitionKey);
    if (!sm) {
        sm = [[LSStateMachine alloc] init];
        objc_setAssociatedObject (
                                  klass,
                                  &LSStateMachineDefinitionKey,
                                  sm,
                                  OBJC_ASSOCIATION_RETAIN
                                  );
        definition(sm);
    }
    return sm;
    
}
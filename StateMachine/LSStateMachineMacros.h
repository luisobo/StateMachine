#ifndef StateMachine_LSStateMachineMacros_h
#define StateMachine_LSStateMachineMacros_h
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define STATE_MACHINE(definition) \
+ (LSStateMachine *)stateMachine {\
    return LSStateMachineSetDefinitionForClass(self, definition);\
}\
+ (void) initialize {\
    LSStateMachineInitializeClass(self);\
}
#endif

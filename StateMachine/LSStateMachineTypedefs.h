#ifndef StateMachine_LSStateMachineTypedefs_h
#define StateMachine_LSStateMachineTypedefs_h

typedef void(^LSStateMachineTransitionCallback)(id object);
typedef BOOL(^LSStateMachineTransitionCondition)(id object);

#endif

#import <Foundation/Foundation.h>

@class LSStateMachine;

LSStateMachine * LSStateMachineSetDefinitionForClass(Class klass,void(^definition)(LSStateMachine *));
void LSStateMachineInitializeClass(Class klass);
#import <Foundation/Foundation.h>
#import "LSStateMachineTypedefs.h"

@class LSEvent;

@interface LSStateMachine : NSObject
@property (nonatomic, strong, readonly) NSSet *states;
@property (nonatomic, strong, readonly) NSSet *events;
@property (nonatomic, strong, readonly) NSDictionary *enteringCallbacks;
@property (nonatomic, strong, readonly) NSDictionary *exitingCallbacks;

@property (nonatomic, strong) NSString *initialState;

- (void)addState:(NSString *)state;
- (void)when:(NSString *)eventName transitionFrom:(NSString *)from to:(NSString *)to;
- (LSEvent *)eventWithName:(NSString *)name;

- (void)before:(NSString *)eventName do:(LSStateMachineTransitionCallback)callback;
- (void)after:(NSString *)eventName do:(LSStateMachineTransitionCallback)callback;
- (void)entering:(NSString *)state do:(LSStateMachineTransitionCallback)callback;
- (void)exiting:(NSString *)state do:(LSStateMachineTransitionCallback)callback;

- (NSString *)nextStateFrom:(NSString *)from forEvent:(NSString *)event;

@end
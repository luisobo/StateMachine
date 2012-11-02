#import <Foundation/Foundation.h>

@class LSTransition;

typedef void(^LSStateMachineTransitionCallback)(id object);

@interface LSEvent : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSSet *transitions;
@property (nonatomic, strong, readonly) NSArray *beforeCallbacks;
@property (nonatomic, strong, readonly) NSArray *afterCallbacks;

+ (id)eventWithName:(NSString *)name transitions:(NSSet *)transitions;
- (id)initWithName:(NSString *)name transitions:(NSSet *)transitions;

+ (id)eventWithName:(NSString *)name
        transitions:(NSSet *)transitions
    beforeCallbacks:(NSArray *)beforeCallbacks
    afterCallbacks:(NSArray *)afterCallbacks;

- (id)initWithName:(NSString *)name
       transitions:(NSSet *)transitions
   beforeCallbacks:(NSArray *)beforeCallbacks
    afterCallbacks:(NSArray *)afterCallbacks;

- (LSEvent *)addTransition:(LSTransition *)transition;
- (LSEvent *)addBeforeCallback:(LSStateMachineTransitionCallback)beforeCallback;
- (LSEvent *)addAfterCallback:(LSStateMachineTransitionCallback)afterCallback;
@end

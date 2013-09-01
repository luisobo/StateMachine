#import <Foundation/Foundation.h>
#import "LSStateMachineTypedefs.h"

@class LSTransition;

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

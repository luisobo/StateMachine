#import <Foundation/Foundation.h>

@interface LSStateMachine : NSObject
@property (nonatomic, strong, readonly) NSSet *states;
@property (nonatomic, strong, readonly) NSSet *transitions;
@property (nonatomic, strong) NSString *initialState;
- (void)addState:(NSString *)state;
- (void)addTransition:(NSString *)eventName from:(NSString *)initialState to:(NSString *)finalState;
@end

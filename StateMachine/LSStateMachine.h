#import <Foundation/Foundation.h>

@interface LSStateMachine : NSObject
@property (nonatomic, strong, readonly) NSSet *states;
@property (nonatomic, strong, readonly) NSSet *events;
@property (nonatomic, strong) NSString *initialState;
- (void)addState:(NSString *)state;
- (void)when:(NSString *)eventName transitionFrom:(NSString *)from to:(NSString *)to;
@end

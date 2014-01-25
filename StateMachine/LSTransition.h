#import <Foundation/Foundation.h>
#import "LSStateMachineTypedefs.h"

@interface LSTransition : NSObject
+ (id)transitionFrom:(NSString *)from to:(NSString *)to;
- (id)initFrom:(NSString *)from to:(NSString *)to;
- (BOOL)checkCondition;
@property (nonatomic, copy, readonly) NSString *from;
@property (nonatomic, copy, readonly) NSString *to;
@property (nonatomic, copy) LSStateMachineTransitionCondition condition;
@end

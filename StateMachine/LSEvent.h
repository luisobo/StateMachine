#import <Foundation/Foundation.h>

@class LSTransition;

@interface LSEvent : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSSet *transitions;
+ (id)eventWithName:(NSString *)name transitions:(NSSet *)transitions;
- (id)initWithName:(NSString *)name transitions:(NSSet *)transitions;
- (LSEvent *)addTransition:(LSTransition *)transition;
@end

#import <Foundation/Foundation.h>

@class LSTransition;

@interface LSEvent : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSSet *transitions;
@property (nonatomic, strong, readonly) NSArray *beforeCallbacks;

+ (id)eventWithName:(NSString *)name transitions:(NSSet *)transitions;
- (id)initWithName:(NSString *)name transitions:(NSSet *)transitions;

+ (id)eventWithName:(NSString *)name transitions:(NSSet *)transitions beforeCallbacks:(NSArray *)beforeCallbacks;
- (id)initWithName:(NSString *)name transitions:(NSSet *)transitions beforeCallbacks:(NSArray *)beforeCallbacks;

- (LSEvent *)addTransition:(LSTransition *)transition;
- (LSEvent *)addBeforeCallback:(void(^)(id))beforeCallback;
@end

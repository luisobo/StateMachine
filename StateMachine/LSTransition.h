#import <Foundation/Foundation.h>

@interface LSTransition : NSObject
+ (id)transitionFrom:(NSString *)from to:(NSString *)to;
- (id)initFrom:(NSString *)from to:(NSString *)to;
@property (nonatomic, copy, readonly) NSString *from;
@property (nonatomic, copy, readonly) NSString *to;
@end

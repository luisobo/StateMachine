#import "LSEvent.h"

@implementation LSEvent
+ (id)eventWithName:(NSString *)name transitions:(NSSet *)transitions{
    return [[self alloc] initWithName:name transitions:transitions];
}
- (id)initWithName:(NSString *)name transitions:(NSSet *)transitions{
    self = [self initWithName:name transitions:transitions beforeCallbacks:[[NSArray alloc] init]];
    return self;
}

+ (id)eventWithName:(NSString *)name transitions:(NSSet *)transitions beforeCallbacks:(NSArray *)beforeCallbacks {
    return [[self alloc] initWithName:name transitions:transitions beforeCallbacks:beforeCallbacks];
}
- (id)initWithName:(NSString *)name transitions:(NSSet *)transitions beforeCallbacks:(NSArray *)beforeCallbacks{
    self = [super init];
    if (self) {
        _name = [name copy];
        _transitions = (transitions) ? transitions : [[NSSet alloc] init];
        _beforeCallbacks = (beforeCallbacks) ? beforeCallbacks : [[NSArray alloc] init];
    }
    return self;
}

- (LSEvent *)addTransition:(LSTransition *)transition {
    return [LSEvent eventWithName:self.name transitions:[self.transitions setByAddingObject:transition]];
}

- (LSEvent *)addBeforeCallback:(void(^)(id))beforeCallback {
    return [LSEvent eventWithName:self.name
                      transitions:self.transitions
                  beforeCallbacks:[self.beforeCallbacks arrayByAddingObject:beforeCallback]];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    LSEvent *other = (LSEvent *)object;
    if (![self.name isEqualToString:other.name]) {
        return NO;
    }
    if (![self.transitions isEqual:other.transitions]) {
        return NO;
    }
    return YES;
}

- (NSUInteger) hash {
    NSUInteger result = 17;
    result = 31 * result + self.name.hash;
    result = 31 * result + self.transitions.hash;
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ named '%@' with transitions: '%@'", [self class], self.name, self.transitions];
}
@end

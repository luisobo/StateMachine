#import "LSSubscripton.h"
#import "StateMachine.h"
@implementation LSSubscripton

STATE_MACHINE(^(LSStateMachine * sm) {
    sm.initialState = @"pending";
    
    [sm addState:@"pending"];
    [sm addState:@"active"];
    [sm addState:@"suspended"];
    [sm addState:@"terminated"];
    
    [sm when:@"activate" transitionFrom:@"pending" to:@"active"];
    [sm when:@"suspend" transitionFrom:@"active" to:@"suspended"];
    [sm when:@"unsuspend" transitionFrom:@"suspended" to:@"active"];
    [sm when:@"terminate" transitionFrom:@"active" to:@"terminated"];
    [sm when:@"terminate" transitionFrom:@"suspended" to:@"terminated"];
})

- (id)init {
    self = [super init];
    if (self) {
        [self initializeStateMachine];
    }
    return self;
}
@end

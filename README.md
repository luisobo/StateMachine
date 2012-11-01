# StateMachine

State machine library for Objective-C

This library was inspired by INSERT STATE MACHINE LINK HERE.

## Features
* DSL for defining the state machine of your classes
* Dynamically added methods to trigger events in the instances of your classes
* Methods to query if an object is in a certain state (isActive, isPending, etc)
* Methods to query wheter an event will trigger a valid transition or not (canActive, canSuspend, etc)
* Transition callbacks (only support for 'before' transition for the moment). Execute arbitrary code when a certain transition occurs.

## Installation
_WIP_ (please, read: You figure it out, and then you tell me)

* StateMachine will be a [CocoaPod](http://cocoapods.org/) soon.
* You should be able to add StateMachine to you source tree. If you are using git, consider using a `git submodule`

##Usage

### Defining the state machine of a class

Let's model a Subscription class

At this moment you are responsible of defining a state property like this. In the future this will be handle by StateMachine

```objc
@interface Subscription : NSObject
@property (nonatomic, retain) NSString *state; // Property managed by StateMachine

@property (nonatomic, retain) NSDate *terminatedAt;
@end
```

Here is the fun part. In the implementation of the class we use the StateMachine DSL to define the valid states and events. For each event you define which are the valid transitions.

_The DSL is a work in progress and will change_

You also have to include a call to `initializeStateMachine` in you constructor(s) for the moment. The goal is to remove this limitation and be less intrusive.

```objc
@implementation Subscription

STATE_MACHINE(^(LSStateMachine *sm) {
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
    
    [sm before:@"terminate" do:^(Subscription *subscription){
        subscription.terminatedAt = [NSDate dateWithTimeIntervalSince1970:123123123];
    }];
});

- (id)init {
    self = [super init];
    if (self) {
        [self initializeStateMachine];
    }
    return self;
}

@end
```

StateMachine will methods to your class to trigger events. In order to make the compiler happy you need to tell it that this methods will be there at runtime. You can achieve this by defining the header of an Objective-C category with one method per event (returning BOOL) and the method `initializeStateMachine`. Just like this:

```objc
@interface Subscription (State)
- (void)initializeStateMachine;
- (BOOL)activate;
- (BOOL)suspend;
- (BOOL)unsuspend;
- (BOOL)terminate;

- (BOOL)isPending;
- (BOOL)isActive;
- (BOOL)isSuspended;
- (BOOL)isTerminated;

- (BOOL)canActivate;
- (BOOL)canSuspend;
- (BOOL)canUnsuspend;
- (BOOL)canTerminate;
@end
```

As you can see, StateMachine will define query methods to check if the object is in a certain state (isPending, isActive, etc) and to check whether an event will trigger a valid transition (canActivate, canSuspend, etc).

### Triggering events

Now you can create instances of your class as you would normally do

```objc
Subscription *subscription = [[Subscription alloc] init];
```

It has an initialState of `pending`

```objc
subscription.state; // @"pending"
```

You can trigger events
```objc
[subscription activate]; // retuns YES because it's a valid transition
subscription.state; // @"active"

[subscription suspend]; // retuns YES because it's a valid transition
subscription.state; // @"suspended"

[subscription terminate]; // retuns YES because it's a valid transition
subscription.state; // @"terminated"
subcription.terminatedAt; // NSDate dateWithTimeIntervalSince1970:123123123];
```

If we trigger an invalid event
```objc
// The subscription is now suspended
[subscription activate]; // retuns NO because it's not a valid transition
subscription.state; // @"suspended"
```


//
//  NSString+Capitalize.m
//  StateMachine
//
//  Created by Steven Luscher on 2013-02-25.
//  Copyright (c) 2013 Luis Solano Bonet. All rights reserved.
//

#import "NSString+Capitalize.h"

@implementation NSString (Capitalize)
- (NSString *)initialCapital
{
    NSString *firstLetter = [self substringToIndex:1];
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[firstLetter uppercaseString]];
}
- (NSString *)initialLowercase
{
    NSString *firstLetter = [self substringToIndex:1];
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[firstLetter lowercaseString]];
}
@end

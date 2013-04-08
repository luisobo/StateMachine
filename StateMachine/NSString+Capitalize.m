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

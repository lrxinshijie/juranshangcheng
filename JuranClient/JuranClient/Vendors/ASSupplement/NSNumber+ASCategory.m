//
//  NSNumber+ASCategory.m
//  Miniu
//
//  Created by Kowloon on 15/4/22.
//
//

#import "NSNumber+ASCategory.h"

@implementation NSNumber (ASCategory)

- (NSString *)decimalNumberFormatter{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *retVal = [numberFormatter stringFromNumber:@([self longLongValue]/100.0)];
    retVal = [retVal stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    retVal = [retVal stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return retVal;
}

- (NSString *)numberFormatter{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *retVal = [numberFormatter stringFromNumber:self];
    return retVal;
}

@end

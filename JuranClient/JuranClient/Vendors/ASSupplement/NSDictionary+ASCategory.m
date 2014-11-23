//
//  NSDictionary+ASCategory.m
//  Supplement
//
//  Created by Kowloon on 12-4-17.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "NSDictionary+ASCategory.h"
#import "NSObject+ASCategory.h"

static NSString * PercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)kAFCharactersToLeaveUnescaped, (CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@implementation NSDictionary (ASCategory)

- (id)objectForTreeStyleKey:(NSString*)key 
{
	NSArray *keys = [key componentsSeparatedByString:@"/"];
	NSDictionary *dictionary = [self copy];
    NSInteger count = [keys count];
	for (NSInteger n = 0; n < count - 1; n ++) {
		dictionary = [dictionary objectForKey:[keys objectAtIndex:n]];
	}
	return [dictionary objectForKey:[keys objectAtIndex:count - 1]];
}

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] intValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (double)getDoubleValueForKey:(NSString *)key defaultValue:(double)defaultValue{
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] doubleValue];
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
	return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]
    ? defaultValue : [self objectForKey:key];
}

- (NSDate *)getDateValueForKey:(NSString *)key defaultValue:(NSDate *)defaultValue{
    if ([self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]) {
        return defaultValue;
    }else {
        return [NSDate dateWithTimeIntervalSince1970:[[self objectForKey:key] doubleValue]/1000];
    }
}

- (NSString *)buildUpWithParameters
{
    NSDictionary *parameters = self;
    NSArray *keys = [parameters allKeys];
    NSMutableArray *components = [NSMutableArray array];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *field = PercentEscapedQueryStringPairMemberFromStringWithEncoding([self stringValueFromValue:obj], NSUTF8StringEncoding);
        NSString *value = PercentEscapedQueryStringPairMemberFromStringWithEncoding([self stringValueFromValue:[parameters objectForKey:obj]], NSUTF8StringEncoding);
        [components addObject:[NSString stringWithFormat:@"%@=%@", field, value]];
    }];
    
    NSString *result = [components componentsJoinedByString:@"&"];
    return result;
}

@end

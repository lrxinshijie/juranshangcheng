//
//  NSDictionary+ASCategory.h
//  Supplement
//
//  Created by Kowloon on 12-4-17.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ASCategory)

- (id)objectForTreeStyleKey:(NSString*)key;     //format the key to string separated by "/", eg. key/subkey

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (double)getDoubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;
- (NSDate *)getDateValueForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;
- (NSString *)buildUpWithParameters;

@end

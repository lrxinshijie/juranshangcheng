//
//  NSMutableArray+ASCategory.m
//  Supplement
//
//  Created by Kowloon on 12-4-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "NSMutableArray+ASCategory.h"
#import "NSDictionary+ASCategory.h"
#import "NSArray+ASCategory.h"

@implementation NSMutableArray (ASCategory)

- (void)sortUsingSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self sortUsingDescriptors:sortDescriptors];
}

- (void)sortUsingSortDescriptorWithKeys:(NSArray *)keys
{
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for (int i = 0; i<[keys count]; i++) {
        NSDictionary *theKey = [keys objectAtTheIndex:i];
        NSString *key = [theKey.allKeys lastObject];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:[theKey getBoolValueForKey:key defaultValue:YES]];
        [sortDescriptors addObject:sortDescriptor];
    }
    [self sortUsingDescriptors:sortDescriptors];
}

@end

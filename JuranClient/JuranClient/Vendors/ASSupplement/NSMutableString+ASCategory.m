//
//  NSMutableString+ASCategory.m
//  Supplement
//
//  Created by Kowloon on 12-6-11.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "NSMutableString+ASCategory.h"

@implementation NSMutableString (ASCategory)

- (void)appendTreeStyleString:(NSString *)string 
{
    NSArray *appendedStrings = [string componentsSeparatedByString:@"/"];
    for (NSString *appendedString in appendedStrings) {
        [self appendString:appendedString];
    }
}

@end

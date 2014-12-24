//
//  JRSubject.m
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRSubject.h"

@implementation JRSubject

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.key = [dict getIntValueForKey:@"id" defaultValue:0];
        self.subjectUrl = [dict getStringValueForKey:@"subjectUrl" defaultValue:@""];
        self.subjectName = [dict getStringValueForKey:@"subjectName" defaultValue:@""];
        self.subjectContent = [dict getStringValueForKey:@"subjectContent" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRSubject *s = [[JRSubject alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

@end

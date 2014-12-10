//
//  JRQuestion.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRQuestion.h"

@implementation JRQuestion

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.questionId = [dict getIntValueForKey:@"questionId" defaultValue:0];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.questionType = [dict getIntValueForKey:@"questionType" defaultValue:0];
//        self.userId = [dict getStringValueForKey:@"userId" defaultValue:@""];
//        self.userType = [dict getStringValueForKey:@"userType" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRQuestion *s = [[JRQuestion alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (BOOL)isResolved{
    BOOL flag = NO;
    
    return flag;
}


@end

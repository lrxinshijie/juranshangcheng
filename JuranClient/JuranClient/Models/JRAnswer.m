//
//  JRAnswer.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRAnswer.h"

@implementation JRAnswer

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.answerId = [dict getIntValueForKey:@"answerId" defaultValue:0];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.questionType = [dict getIntValueForKey:@"questionType" defaultValue:0];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        self.commitTime = [dict getStringValueForKey:@"commitTime" defaultValue:@""];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRAnswer *s = [[JRAnswer alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (BOOL)isResolved{
    BOOL flag = NO;
    if ([_status isEqualToString:@"resolved"]){
        flag = YES;
    }
    return flag;
}

@end

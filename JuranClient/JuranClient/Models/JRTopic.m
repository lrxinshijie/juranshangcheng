//
//  JRTopic.m
//  JuranClient
//
//  Created by song.he on 14-12-4.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRTopic.h"

@implementation JRTopic


- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.topicId = [dict getStringValueForKey:@"topicId" defaultValue:@""];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        self.commentDate = [dict getStringValueForKey:@"commentDate" defaultValue:@""];
        self.commentImageUrlList = dict[@"commentImageUrlList"];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRTopic *t = [[JRTopic alloc] initWithDictionary:item];
            [retVal addObject:t];
        }
    }
    return retVal;
}

@end

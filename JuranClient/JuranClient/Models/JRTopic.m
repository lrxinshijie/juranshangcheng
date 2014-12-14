//
//  JRTopic.m
//  JuranClient
//
//  Created by song.he on 14-12-4.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRTopic.h"
#import "JRComment.h"

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
        id obj = dict[@"commentImageUrlList"];
        if ([obj isKindOfClass:[NSNull class]]) {
            self.commentImageUrlList = @[];
        }else{
            self.commentImageUrlList = obj;
        }
        
    }
    
    return self;
}

- (id)initWithDictionaryForDetail:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.topicId = [dict getStringValueForKey:@"topicId" defaultValue:@""];
        self.theme = [dict getStringValueForKey:@"theme" defaultValue:@""];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.contentUrl = [dict getStringValueForKey:@"contentUrl" defaultValue:@""];
        self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0];
        self.commentCount = [dict getIntValueForKey:@"commentCount" defaultValue:0];
        self.commentImageUrlList = [JRComment buildUpWithValue:dict[@"commitList"]];
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

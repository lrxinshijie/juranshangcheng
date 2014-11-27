//
//  JRCase.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRCase.h"

@implementation JRCase

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.likeCount = [dict getIntValueForKey:@"likeCount" defaultValue:0];
        self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0]; //same with member_id
        self.commentCount = [dict getIntValueForKey:@"commentCount" defaultValue:0];
        
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.desc = [dict getStringValueForKey:@"desc" defaultValue:@""];
        self.userType = [dict getStringValueForKey:@"userType" defaultValue:@""];
        self.memo = [dict getStringValueForKey:@"memo" defaultValue:@""];
        self.imageUrl = [dict getStringValueForKey:@"imageUrl" defaultValue:@""];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.projectId = [dict getStringValueForKey:@"projectId" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        
        self.isFav = [dict getBoolValueForKey:@"isFav" defaultValue:NO];
        self.isLike = [dict getBoolValueForKey:@"isLike" defaultValue:NO];
        
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRCase *s = [[JRCase alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (NSURL *)imageURL{
    return [NSURL URLWithString:self.imageUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

@end

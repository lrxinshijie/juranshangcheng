//
//  JRComment.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRComment.h"

@implementation JRComment

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.commentId = [dict getIntValueForKey:@"commentId" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.commentContent = [dict getStringValueForKey:@"commentContent" defaultValue:@""];
        self.commentTime = [dict getStringValueForKey:@"commentTime" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.userType = [dict getStringValueForKey:@"userType" defaultValue:@""];
        
        
        
        self.replyId = [dict getIntValueForKey:@"replyId" defaultValue:0];
        self.replyContent = [dict getStringValueForKey:@"replyContent" defaultValue:@""];
        self.replyTime = [dict getStringValueForKey:@"replyTime" defaultValue:@""];
        
        NSArray *replyList = [dict objectForKey:@"replyList"];
        if (replyList && [replyList isKindOfClass:[NSArray class]]) {
            self.replyList = [JRComment buildUpWithValue:replyList];
        }
        
        self.unfold = YES;
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRComment *s = [[JRComment alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

@end

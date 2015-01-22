//
//  PrivateMessage.m
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PrivateMessage.h"

@implementation PrivateMessage

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.letterId = [dict getIntValueForKey:@"letterId" defaultValue:0];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.senderId = [dict getIntValueForKey:@"senderId" defaultValue:0];
        self.senderHeadUrl = [dict getStringValueForKey:@"senderHeadUrl" defaultValue:@""];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        self.publishCustomTime = [dict getStringValueForKey:@"publishCustomTime" defaultValue:@""];
        self.unReadNum = [dict getIntValueForKey:@"unReadNum" defaultValue:0];
        self.receiverId = [dict getIntValueForKey:@"receiverId" defaultValue:0];
        self.receiverHeadUrl = [dict getStringValueForKey:@"receiverHeadUrl" defaultValue:@""];
        self.senderNickName = [dict getStringValueForKey:@"senderNickName" defaultValue:@""];
        self.receiverNickName = [dict getStringValueForKey:@"receiverNickName" defaultValue:@""];
        
    }
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            PrivateMessage *s = [[PrivateMessage alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

@end

@implementation PrivateMessageDetail

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.letterId = [dict getIntValueForKey:@"letterId" defaultValue:0];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.fromUserId = [dict getIntValueForKey:@"fromUserId" defaultValue:0];
        self.fromNickName = [dict getStringValueForKey:@"fromNickName" defaultValue:@""];
        self.fromHeadUrl = [dict getStringValueForKey:@"fromHeadUrl" defaultValue:@""];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        self.letterContentId = [dict getIntValueForKey:@"letterContentId" defaultValue:0];
        self.toUserId = [dict getIntValueForKey:@"toUserId" defaultValue:0];
        self.toNickName = [dict getStringValueForKey:@"toNickName" defaultValue:@""];
        self.toHeadUrl = [dict getStringValueForKey:@"toHeadUrl" defaultValue:@""];
        self.isRead = [dict getStringValueForKey:@"isRead" defaultValue:@"N"];
        
        self.sort = [dict getIntValueForKey:@"sort" defaultValue:0];
    }
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            PrivateMessageDetail *s = [[PrivateMessageDetail alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

@end

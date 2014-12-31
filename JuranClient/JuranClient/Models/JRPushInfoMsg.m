//
//  JRPushInfoMsg.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRPushInfoMsg.h"

@implementation JRPushInfoMsg

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.msgId = [dict getIntValueForKey:@"msgId" defaultValue:0];
        self.msgType = [dict getIntValueForKey:@"msgType" defaultValue:0];
        self.isUnread = [dict getIntValueForKey:@"isUnread" defaultValue:0];

        self.gmtMsgExpire = [dict getStringValueForKey:@"gmtMsgExpire" defaultValue:@""];
        self.msgTitle = [dict getStringValueForKey:@"msgTitle" defaultValue:@""];
        self.gmtCreate = [dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
        self.msgAbstract = [dict getStringValueForKey:@"msgAbstract" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRPushInfoMsg *msg = [[JRPushInfoMsg alloc] initWithDictionary:item];
            [retVal addObject:msg];
        }
    }
    return retVal;
}

- (void)buildUpDetailWithValue:(id)value{
    if (!value || ![value isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    self.msgImgUrl = [value getStringValueForKey:@"msgImgUrl" defaultValue:@""];
    self.msgContent = [value getStringValueForKey:@"msgContent" defaultValue:@""];
    self.msgLinkTitle = [value getStringValueForKey:@"msgLinkTitle" defaultValue:@""];
    self.msgLinkUrl = [value getStringValueForKey:@"msgLinkUrl" defaultValue:@""];
    self.msgUrlType = [value getIntValueForKey:@"msgUrlType" defaultValue:0];
    self.msgUrl = [value getStringValueForKey:@"msgUrl" defaultValue:@""];
}

@end

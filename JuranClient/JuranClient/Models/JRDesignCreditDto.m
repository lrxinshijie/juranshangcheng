//
//  JRDesignCreditDto.m
//  JuranClient
//
//  Created by HuangKai on 15/2/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRDesignCreditDto.h"

@implementation JRDesignCreditDto


- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.creditID = [dict getIntValueForKey:@"id" defaultValue:0];
        self.consumerId = [dict getIntValueForKey:@"consumerId" defaultValue:0];
        self.consumerNickname = [dict getStringValueForKey:@"consumerNickname" defaultValue:@""];
        self.providerId = [dict getIntValueForKey:@"providerId" defaultValue:0];
        self.providerNickname = [dict getStringValueForKey:@"providerNickname" defaultValue:@""];
        self.tid = [dict getStringValueForKey:@"tid" defaultValue:@""];
        self.type = [dict getIntValueForKey:@"type" defaultValue:0];
        self.capacityPoint = [dict getIntValueForKey:@"capacityPoint" defaultValue:0];
        self.servicePoint = [dict getIntValueForKey:@"servicePoint" defaultValue:0];
        self.punctualityPoint = [dict getIntValueForKey:@"punctualityPoint" defaultValue:0];
        self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
        self.gmtCreate = [dict getStringValueForKey:@"appGmtCreate" defaultValue:@""];
        self.ifAnony = [dict getIntValueForKey:@"ifAnony" defaultValue:0];
        self.ifHide = [dict getIntValueForKey:@"ifHide" defaultValue:0];
        self.status = [dict getIntValueForKey:@"status" defaultValue:0];
        self.replyContent = [dict getStringValueForKey:@"replyContent" defaultValue:@""];
        self.appendContent = [dict getStringValueForKey:@"appendContent" defaultValue:@""];
        self.replyAppendContent = [dict getStringValueForKey:@"replyAppendContent" defaultValue:@""];
        self.ifAddCredit = [dict getStringValueForKey:@"ifAddCredit" defaultValue:@""];
        self.customerHeadUrl = [dict getStringValueForKey:@"customerHeadUrl" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRDesignCreditDto *s = [[JRDesignCreditDto alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}


@end

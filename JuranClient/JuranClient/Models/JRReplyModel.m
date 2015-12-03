//
//  JRReplyModel.m
//  JuranClient
//
//  Created by 123 on 15/11/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRReplyModel.h"

@implementation JRReplyModel
- (id)initWithDictionary:(NSDictionary *)dict{

    if(self=[super init])
    {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.replyId = [dict getIntValueForKey:@"replyId" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.userNickname=[dict getStringValueForKey:@"userNickname" defaultValue:@""];
        self.content=[dict getStringValueForKey:@"content" defaultValue:@""];
        self.gmtCreate=[dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
        self.replyNickname=[dict getStringValueForKey:@"replyNickname" defaultValue:@""];

        self.rid=[dict getIntegerValueForKey:@"id" defaultValue:0];
//        @property (nonatomic, copy) NSString *replyNickname; //回复的用户昵称

    }
    return self;

}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRReplyModel *s = [[JRReplyModel alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

@end

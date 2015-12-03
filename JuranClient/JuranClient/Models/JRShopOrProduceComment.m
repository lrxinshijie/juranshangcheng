 //
//  JRShopOrProduceComment.m
//  JuranClient
//
//  Created by 123 on 15/11/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRShopOrProduceComment.h"


@implementation JRShopOrProduceComment

- (id)initWithDictionary:(NSDictionary *)dict{
    
    if(self=[super init])
    {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.id = [dict getIntValueForKey:@"id" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.userNickname=[dict getStringValueForKey:@"userNickname" defaultValue:@""];
        self.userImg = [dict getStringValueForKey:@"userImg" defaultValue:@""];
        self.rank=[dict getIntegerValueForKey:@"rank" defaultValue:0];
        self.content=[dict getStringValueForKey:@"content" defaultValue:@""];
        self.gmtCreate=[dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
        self.vote=[dict getIntegerValueForKey:@"vote" defaultValue:0];
        self.relName=[dict getStringValueForKey:@"relName" defaultValue:@""];

        
        NSString *obj = dict[@"img"];
        if(obj && ![obj isKindOfClass:[NSNull class]])
        {
            self.imgList=[obj componentsSeparatedByString:@","];
        }
        
        NSArray *array=dict[@"replyList"];
        self.arrReplyList=[[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            JRReplyModel *model=[[JRReplyModel alloc] initWithDictionary:dic];
            [self.arrReplyList addObject:model];
        }
        
        self.isDelete=NO;
        
        
        
    }
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRShopOrProduceComment *s = [[JRShopOrProduceComment alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end

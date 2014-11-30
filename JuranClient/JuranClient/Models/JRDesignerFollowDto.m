//
//  JRDesignerFollowDto.m
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDesignerFollowDto.h"

@implementation JRDesignerFollowDto

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.followId = [dict getStringValueForKey:@"followId" defaultValue:@""];
        self.userId = [dict getStringValueForKey:@"userId" defaultValue:@""];
        self.followUserId = [dict getStringValueForKey:@"followUserId" defaultValue:@""];
        self.remark = [dict getStringValueForKey:@"remark" defaultValue:@""];
        self.gmtCreate = [dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
        self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.priceMeasure = [dict getIntValueForKey:@"priceMeasure" defaultValue:0];
        self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
        self.designFeeMin = [dict getIntValueForKey:@"designFeeMin" defaultValue:0];
        self.designFeeMax = [dict getIntValueForKey:@"designFeeMax" defaultValue:0];
        self.introduction = [dict getStringValueForKey:@"introduction" defaultValue:@""];
        self.realNameAuth = [dict getStringValueForKey:@"realNameAuth" defaultValue:@""];
        self.weight = [dict getStringValueForKey:@"weight" defaultValue:@""];
        self.browseCount = [dict getStringValueForKey:@"browseCount" defaultValue:@""];
        self.project2DCount = [dict getStringValueForKey:@"project2DCount" defaultValue:@""];
        self.project3DCount = [dict getStringValueForKey:@"project3DCount" defaultValue:@""];
        self.followedCount = [dict getStringValueForKey:@"followedCount" defaultValue:@""];
        self.evaluationCount = [dict getStringValueForKey:@"evaluationCount" defaultValue:@""];
        self.tradeCount = [dict getStringValueForKey:@"tradeCount" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRDesignerFollowDto *d = [[JRDesignerFollowDto alloc] initWithDictionary:item];
            [retVal addObject:d];
        }
    }
    return retVal;
}

- (NSURL *)headImageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

@end

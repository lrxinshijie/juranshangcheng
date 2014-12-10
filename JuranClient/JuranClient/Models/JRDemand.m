//
//  JRDemand.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDemand.h"

@implementation JRDemand

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.designReqId = [dict getIntValueForKey:@"designReqId" defaultValue:0];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
        self.houseType = [dict getStringValueForKey:@"houseType" defaultValue:@""];
        self.renovationBudget = [dict getIntValueForKey:@"renovationBudget" defaultValue:0];
        self.bidNums = [dict getIntValueForKey:@"bidNums" defaultValue:0];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.houseAddress = [dict getStringValueForKey:@"houseAddress" defaultValue:@""];
        self.houseArea = [dict getIntValueForKey:@"houseArea" defaultValue:0];
        self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
        self.deadline = [dict getStringValueForKey:@"deadline" defaultValue:@""];
        self.newBidNums = [dict getIntValueForKey:@"newBidNums" defaultValue:0];
        self.isBidded = [dict getBoolValueForKey:@"isBidded" defaultValue:NO];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRDemand *t = [[JRDemand alloc] initWithDictionary:item];
            [retVal addObject:t];
        }
    }
    return retVal;
}

- (NSString*)statusString{
    NSArray *keys = @[@"01_waitAudit", @"02_refusal", @"03_pass", @"04_complete", @"05_close", @"06_falied"];
    NSArray *values = @[@"待审核", @"审核拒绝", @"进行中", @"已完成", @"已结束", @"已流标"];
    NSInteger index = 0;
    for (NSString *key in keys) {
        if ([key isEqualToString:_status]) {
            break;
        }
        index++;
    }
    return values[index];
}

@end

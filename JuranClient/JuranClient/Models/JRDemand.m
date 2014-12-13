//
//  JRDemand.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDemand.h"
#import "JRAreaInfo.h"

@implementation JRDemand

- (instancetype)init{
    if (self = [super init]) {
        self.areaInfo = [[JRAreaInfo alloc] init];
        self.status = @"";
        self.title = @"";
        self.houseType = @"";
        self.publishTime = @"";
        self.houseAddress = @"";
        self.style = @"";
        self.deadline = @"";
        self.contactsName = @"";
        self.contactsMobile = @"";
        self.budget = @"";
        self.budgetUnit = @"";
        self.renovationStyle = @"";
        self.neighbourhoods = @"";
        self.roomNum = @"";
    }
    
    return self;
}

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

- (NSString *)houseTypeString{
    NSDictionary *dic =  @{@"residential" : @"住宅空间",
                           @"catering": @"餐饮空间",
                           @"office": @"办公空间",
                           @"hotel": @"酒店空间",
                           @"commercial": @"商业展示",
                           @"entertainment": @"娱乐空间",
                           @"leisure": @"休闲场所",
                           @"culture": @"文化空间",
                           @"medical": @"医疗机构",
                           @"salescenter": @"售楼中心",
                           @"financial": @"金融场所",
                           @"movement": @"运动场所",
                           @"education": @"教育机构",
                           @"other": @"其他"};
    
    return dic[_houseType];
}

- (NSString *)renovationStyleString{
    return @"";
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

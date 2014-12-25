//
//  JRDemand.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDemand.h"
#import "JRAreaInfo.h"
#import "JRBidInfo.h"

@implementation JRDemand

- (instancetype)init{
    if (self = [super init]) {
        self.areaInfo = [[JRAreaInfo alloc] init];
        self.status = @"";
        self.designReqId = @"";
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
        self.livingroomCount = @"";
        self.bathroomCount = @"";
        self.roomTypeImgUrl = @"";
        self.contactsSex = @"";
        self.roomType = @"";
        self.imageUrl = @"";
        self.bidId = @"";
        self.bidInfoList = [NSMutableArray array];
        self.deadBalance = @"";
        self.postDate = @"";
        self.auditDesc = @"";
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.designReqId = [dict getStringValueForKey:@"designReqId" defaultValue:@""];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
        self.houseType = [dict getStringValueForKey:@"houseType" defaultValue:@""];
        self.renovationBudget = [dict getIntValueForKey:@"renovationBudget" defaultValue:0]/1000000;
        self.bidNums = [dict getIntValueForKey:@"bidNums" defaultValue:0];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.houseAddress = [dict getStringValueForKey:@"houseAddress" defaultValue:@""];
        self.houseArea = [dict getIntValueForKey:@"houseArea" defaultValue:0];
        self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
        self.deadline = [dict getStringValueForKey:@"deadline" defaultValue:@""];
        self.newBidNums = [dict getIntValueForKey:@"newBidNums" defaultValue:0];
        self.isBidded = [dict getBoolValueForKey:@"isBidded" defaultValue:NO];
        self.deadBalance = [dict getStringValueForKey:@"deadBalance" defaultValue:@""];
        self.auditDesc = [dict getStringValueForKey:@"auditDesc" defaultValue:@""];
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

- (void)buildUpDetailWithValue:(id)value{
    if (!(value && [value isKindOfClass:[NSDictionary class]])) {
        return;
    }
    self.contactsName = [value getStringValueForKey:@"contactsName" defaultValue:@""];
    self.contactsSex = [value getStringValueForKey:@"contactsSex" defaultValue:@""];
    self.contactsMobile = [value getStringValueForKey:@"contactsMobile" defaultValue:@""];
    self.budget = [NSString stringWithFormat:@"%d", [value getIntValueForKey:@"budget" defaultValue:0]/1000000];
    self.renovationStyle = [value getStringValueForKey:@"renovationStyle" defaultValue:@""];
    NSDictionary *areaDic = value[@"areaInfo"];
    self.areaInfo = [[JRAreaInfo alloc] initWithDictionary:areaDic];
    
    self.neighbourhoods = [value getStringValueForKey:@"neighbourhoods" defaultValue:@""];
    self.roomType = [value getStringValueForKey:@"roomType" defaultValue:@""];
    self.imageUrl = [value getStringValueForKey:@"imageUrl" defaultValue:@""];
    self.bidId = [value getStringValueForKey:@"bidId" defaultValue:@""];
    self.deadBalance = [value getStringValueForKey:@"deadBalance" defaultValue:@""];
    self.postDate = [value getStringValueForKey:@"postDate" defaultValue:@""];
    self.auditDesc = [value getStringValueForKey:@"auditDesc" defaultValue:@""];
    self.bidNums = [value getIntValueForKey:@"bidNums" defaultValue:0];
    self.deadline = [value getStringValueForKey:@"deadline" defaultValue:@""];
    self.bidInfoList = [JRBidInfo buildUpWithValue:value[@"bidInfoList"]];
    
}

- (NSString *)houseTypeString{
    if (_houseType.length == 0) {
        return @"";
    }
    NSArray *houseType = [[DefaultData sharedData] houseType];
    for (int i = 0; i<[houseType count]; i++) {
        NSDictionary *row = [houseType objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.houseType]) {
            return [row objectForKey:@"k"];
        }
    }
    
    return @"";
}

- (NSString *)renovationStyleString{
    if (self.renovationStyle.length == 0) {
        return @"";
    }
    NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
    for (int i = 0; i<[renovationStyle count]; i++) {
        NSDictionary *row = [renovationStyle objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.renovationStyle]) {
            return [row objectForKey:@"k"];
        }
    }
    
    return @"";
}

- (NSString *)roomNumString{
    
    NSMutableArray *retVals = [NSMutableArray array];
//    if (_roomNum.length > 0) {
//        return _roomNum;
//    }
    
    NSArray *roomNum = [[DefaultData sharedData] roomNum];
    for (int i = 0; i<[roomNum count]; i++) {
        NSDictionary *row = [roomNum objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.roomNum]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
    for (int i = 0; i<[livingroomCount count]; i++) {
        NSDictionary *row = [livingroomCount objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.livingroomCount]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
    for (int i = 0; i<[bathroomCount count]; i++) {
        NSDictionary *row = [bathroomCount objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.bathroomCount]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    return [retVals componentsJoinedByString:@""];
}

- (NSString*)statusString{
    
    NSArray *values = @[@"待审核", @"审核拒绝", @"进行中", @"已完成", @"已结束", @"已流标"];
    return values[[self statusIndex]];
}

- (NSInteger)statusIndex{
    NSArray *keys = @[@"01_waitAudit", @"02_refusal", @"03_pass", @"04_complete", @"05_close", @"06_falied"];
    NSInteger index = 0;
    for (NSString *key in keys) {
        if ([key isEqualToString:_status]) {
            break;
        }
        index++;
    }
    return index;
}

- (NSString *)descriptionForDetail{
    NSInteger index = [self statusIndex];
    NSString *des = @"";
    switch (index) {
        case 0:
        {
            des = @"当前平台正在审核您的需求，请您耐心等待，如有问题请联系客服：010-84094000";
            break;
        }
        case 1:
        {
            des = _auditDesc;
            break;
        }
        case 2:
        {
            if (_bidNums > 0) {
                des = [NSString stringWithFormat:@"已有%d人投标，快去选择设计师吧！剩余%@天结束招标。", _bidNums, _deadBalance];
            }else{
                des = [NSString stringWithFormat:@"目前没有设计师投标呦！剩余%@天结束招标。", _deadBalance];
            }
            break;
        }
        case 3:
        {
            des = @"恭喜您！已有心怡的设计师。\n请及时与设计师沟通，相关订单状态可查询订单管理。";
            break;
        }
        case 4:
        {
            des = @"该需求已到期，未有设计师中标，您可再次发布设计需求。";
            break;
        }
        case 5:
        {
            des = @"您终止了该招标需求。";
            break;
        }
        default:
            break;
    }
    return des;
}

@end

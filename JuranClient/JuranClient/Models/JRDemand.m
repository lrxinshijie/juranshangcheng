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
        self.neRoomTypeImgUrl = @"";
        self.bidId = @"";
        self.bidInfoList = [NSMutableArray array];
        self.deadBalance = @"";
        self.postDate = @"";
        self.auditDesc = @"";
        self.roomTypeId = @"";
        self.houseArea = @"";
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
        self.budget = [NSString stringWithFormat:@"%.2f", [dict getDoubleValueForKey:@"renovationBudget" defaultValue:0]/1000000.f];
        self.bidNums = [dict getIntValueForKey:@"bidNums" defaultValue:0];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.houseAddress = [dict getStringValueForKey:@"houseAddress" defaultValue:@""];
        self.houseArea = [dict getStringValueForKey:@"houseArea" defaultValue:@""];
        self.renovationStyle = [dict getStringValueForKey:@"style" defaultValue:@""];
        self.deadline = [dict getStringValueForKey:@"deadline" defaultValue:@""];
        self.newBidNums = [dict getIntValueForKey:@"newBidNums" defaultValue:0];
        self.isBidded = [dict getBoolValueForKey:@"isBidded" defaultValue:NO];
        self.deadBalance = [dict getStringValueForKey:@"deadBalance" defaultValue:@""];
        self.auditDesc = [dict getStringValueForKey:@"auditDesc" defaultValue:@""];
        
#ifdef kJuranDesigner
        self.publishNickName = [dict getStringValueForKey:@"publishNickName" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.memo = [dict getStringValueForKey:@"memo" defaultValue:@""];
        self.bidId = [dict getStringValueForKey:@"bidReqId" defaultValue:@""];
        self.biddingStatus = [dict getStringValueForKey:@"biddingStatus" defaultValue:@""];
#endif
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
    self.budget = [NSString stringWithFormat:@"%.2f", [value getDoubleValueForKey:@"budget" defaultValue:0]/1000000.f];
    self.renovationStyle = [value getStringValueForKey:@"renovationStyle" defaultValue:@""];
    NSDictionary *areaDic = value[@"areaInfo"];
    self.areaInfo = [[JRAreaInfo alloc] initWithDictionary:areaDic];
    
    self.status = [value getStringValueForKey:@"status" defaultValue:@""];
    self.houseType = [value getStringValueForKey:@"houseType" defaultValue:@""];
    self.houseArea = [value getStringValueForKey:@"houseArea" defaultValue:@""];
    self.deadline = [value getStringValueForKey:@"deadline" defaultValue:@""];
    self.newBidNums = [value getIntValueForKey:@"newBidNums" defaultValue:0];
    self.isBidded = [value getBoolValueForKey:@"bided" defaultValue:NO];
    
    self.neighbourhoods = [value getStringValueForKey:@"neighbourhoods" defaultValue:@""];
    self.roomType = [value getStringValueForKey:@"roomType" defaultValue:@""];
    self.neRoomTypeImgUrl = @"";
    _roomTypeImgUrl = [value getStringValueForKey:@"imageUrl" defaultValue:@""];
    self.bidId = [value getStringValueForKey:@"bidId" defaultValue:@""];
    self.deadBalance = [value getStringValueForKey:@"deadBalance" defaultValue:@""];
    self.postDate = [value getStringValueForKey:@"postDate" defaultValue:@""];
    self.auditDesc = [value getStringValueForKey:@"auditDesc" defaultValue:@""];
    self.bidNums = [value getIntValueForKey:@"bidNums" defaultValue:0];
    self.deadline = [value getStringValueForKey:@"deadline" defaultValue:@""];
    self.bidInfoList = [JRBidInfo buildUpWithValue:value[@"bidInfoList"]];
#ifdef kJuranDesigner
#else
    
#endif
    
    
    for (JRBidInfo *b in _bidInfoList) {
        b.statusIndex = [self statusIndex];
    }
    
    id obj = value[@"confirmDesignerDetail"];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        self.confirmDesignerDetail = [[JRBidInfo alloc] initWithDictionary:obj];
        self.confirmDesignerDetail.statusIndex = [self statusIndex];
    }
    
    self.roomNum = [value getStringValueForKey:@"roomNum" defaultValue:@""];
    self.livingroomCount = [value getStringValueForKey:@"livingroomCount" defaultValue:@""];
    self.bathroomCount = [value getStringValueForKey:@"bathroomCount" defaultValue:@""];
    self.roomTypeId = [value getStringValueForKey:@"imageId" defaultValue:@""];
}

+ (NSMutableArray *)buildUpWithValueForDesigner:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRDemand *t = [[JRDemand alloc] initForDesignerWithDictionary:item];
            [retVal addObject:t];
        }
    }
    return retVal;
}

- (id)initForDesignerWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        if (!(dict && [dict isKindOfClass:[NSDictionary class]])) {
            return self;
        }
        
        self.designReqId = [dict getStringValueForKey:@"reqId" defaultValue:@""];
        
        self.budget = [NSString stringWithFormat:@"%.2f", [dict getIntValueForKey:@"budget" defaultValue:0]/1000000.f];
        
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.budgetUnit = [dict getStringValueForKey:@"budgetUnit" defaultValue:@""];
        self.isBidded = [dict getBoolValueForKey:@"isBidded" defaultValue:NO];
        self.houseAddress = [dict getStringValueForKey:@"address" defaultValue:@""];
        self.houseArea = [dict getStringValueForKey:@"houseArea" defaultValue:@""];
        self.deadBalance = [dict getStringValueForKey:@"balanceDays" defaultValue:@""];
        self.bidNums = [dict getIntValueForKey:@"bidNums" defaultValue:0];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
    }
    return self;
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
    return index >= keys.count?0:index;
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
            des = [NSString stringWithFormat:@"很抱歉，您的需求未能通过审核！\n审核不通过原因：%@\n您可以修改后重新发布", _auditDesc];
            break;
        }
        case 2:
        {
            if (_bidNums > 0) {
                des = [NSString stringWithFormat:@"已有%d人投标，快去选择设计师吧！", _bidNums];
            }else{
                des = @"目前没有设计师投标呦！";
            }
            if (_deadBalance.integerValue < 1) {
                des = [NSString stringWithFormat:@"%@离结束不足1天", des];
            }else{
                des = [NSString stringWithFormat:@"%@剩余%@天结束招标。", des, _deadBalance];
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
            des = @"您终止了该招标需求。";
            break;
        }
        case 5:
        {
            des =@"该需求已到期，未有设计师中标，您可再次发布设计需求。";
            break;
        }
        default:
            break;
    }
    return des;
}

- (NSString*)deadBalanceString{
    if (_deadBalance.integerValue < 1) {
        return @"剩余不足1天";
    }
    return [NSString stringWithFormat:@"剩余%@天", _deadBalance];
}

#ifdef kJuranDesigner

- (NSString *)contactsName{
    if (_isBidded) {
        return _contactsName;
    }else{
        return @"设计师应标后可见";
    }
}

- (NSString *)contactsMobile{
    if (_isBidded) {
        return _contactsMobile;
    }else{
        return @"设计师应标后可见";
    }
}

#endif

@end

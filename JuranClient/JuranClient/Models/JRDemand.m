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
        self.livingroomCount = @"";
        self.bathroomCount = @"";
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

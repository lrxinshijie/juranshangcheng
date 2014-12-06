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

@end

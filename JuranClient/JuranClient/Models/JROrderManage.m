//
//  JROrderManage.m
//  JuranClient
//
//  Created by HuangKai on 15/2/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JROrderManage.h"
#import "JRDesignCreditDto.h"

@implementation JROrderManage


- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.capacityPointInfo = [[JRCreditPointsDto alloc] initWithDictionary:dict[@"capacityPointInfo"]];
        self.servicePointInfo = [[JRCreditPointsDto alloc] initWithDictionary:dict[@"servicePointInfo"]];
        self.designCreditList = [NSMutableArray array];
        [self addDesignCreditList:dict[@"designCreditList"]];
    }
    return self;
}

- (void)addDesignCreditList:(id)value{
    NSArray *rows = [JRDesignCreditDto buildUpWithValue:value];
    if (rows.count > 0) {
        [self.designCreditList addObjectsFromArray:rows];
    }
}

@end

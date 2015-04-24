//
//  DataItem.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

- (DataItem *)initDataItemFirstLevelWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.categoryCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"categoryCode"]];
        self.imgStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"imgStr"]];
        self.isOrNoFatherNode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isOrNoFatherNode"]];
        self.name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    }
    return self;
}

+ (DataItem *)createDataItemWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initDataItemFirstLevelWithDictionary:dict];
}

@end

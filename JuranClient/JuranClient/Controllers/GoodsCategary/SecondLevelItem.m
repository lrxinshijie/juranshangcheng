//
//  SecondLevelItem.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/20.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "SecondLevelItem.h"

@implementation SecondLevelItem

- (SecondLevelItem *)initSecondLevelItemWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.lImage = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
        self.lText = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
        self.mImage = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
        self.mText = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
        self.rImage = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
        self.rText = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
        self.isSelect = NO;
        self.selectLocation = Location_None;
    }
    return self;
}

+ (SecondLevelItem *)createSecondLevelItemWithDict:(NSDictionary *)dict
{
    return [[self alloc] initSecondLevelItemWithDict:dict];
}

@end

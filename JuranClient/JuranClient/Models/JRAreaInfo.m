//
//  JRAreaInfo.m
//  JuranClient
//
//  Created by Kowloon on 14/12/9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRAreaInfo.h"

@implementation JRAreaInfo

- (instancetype)init{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (NSDictionary *)dictionaryValue{
    return @{@"provinceName": [NSString stringWithFormat:@"%@", self.provinceName],
             @"cityName": [NSString stringWithFormat:@"%@", self.cityName],
             @"provinceCode": [NSString stringWithFormat:@"%@", self.provinceCode],
             @"districtCode": [NSString stringWithFormat:@"%@", self.districtCode],
             @"districtName": [NSString stringWithFormat:@"%@", self.districtName],
             @"cityCode": [NSString stringWithFormat:@"%@", self.cityCode],
             };
}

@end

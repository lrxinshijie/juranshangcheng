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
        self.cityCode = @"";
        self.cityName = @"";
        self.districtCode = @"";
        self.districtName = @"";
        self.provinceCode = @"";
        self.provinceName = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.provinceCode = [dict getStringValueForKey:@"provinceCode" defaultValue:@""];
        self.provinceName = [dict getStringValueForKey:@"provinceName" defaultValue:@""];
        self.cityCode = [dict getStringValueForKey:@"cityCode" defaultValue:@""];
        self.cityName = [dict getStringValueForKey:@"cityName" defaultValue:@""];
        self.districtCode = [dict getStringValueForKey:@"districtCode" defaultValue:@""];
        self.districtName = [dict getStringValueForKey:@"districtName" defaultValue:@""];
    }
    return self;
}

- (NSString *)title{
    return [NSString stringWithFormat:@"%@%@%@",_provinceName,_cityName,_districtName];
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

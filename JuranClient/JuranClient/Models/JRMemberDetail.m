//
//  JRMemberDetail.m
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRMemberDetail.h"

@implementation JRMemberDetail

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.mobileNum = [dict getStringValueForKey:@"mobileNum" defaultValue:@""];
        self.email = [dict getStringValueForKey:@"email" defaultValue:@""];
        self.birthday = [dict getStringValueForKey:@"birthday" defaultValue:@""];
        self.homeTel = [dict getStringValueForKey:@"homeTel" defaultValue:@""];
        self.provinceCode = [dict getStringValueForKey:@"provinceCode" defaultValue:@""];
        self.provinceName = [dict getStringValueForKey:@"provinceName" defaultValue:@""];
        self.cityCode = [dict getStringValueForKey:@"cityCode" defaultValue:@""];
        self.cityName = [dict getStringValueForKey:@"cityName" defaultValue:@""];
        self.districtCode = [dict getStringValueForKey:@"districtCode" defaultValue:@""];
        self.districtName = [dict getStringValueForKey:@"districtName" defaultValue:@""];
        self.detailAddress = [dict getStringValueForKey:@"detailAddress" defaultValue:@""];
        self.zipCode = [dict getStringValueForKey:@"zipCode" defaultValue:@""];
        self.idCardType = [dict getStringValueForKey:@"idCardType" defaultValue:@""];
        self.qq = [dict getStringValueForKey:@"qq" defaultValue:@""];
        self.weixin = [dict getStringValueForKey:@"weixin" defaultValue:@""];
        self.useablePoints = [dict getIntValueForKey:@"useablePoints" defaultValue:0];
        self.useableExp = [dict getIntValueForKey:@"useableExp" defaultValue:0];
    }
    
    return self;
}

- (NSURL *)headImageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

@end

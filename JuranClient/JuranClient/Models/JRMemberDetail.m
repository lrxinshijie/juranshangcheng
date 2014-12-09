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
        NSDictionary *areaDic = dict[@"areaInfo"];
        self.provinceCode = [areaDic getStringValueForKey:@"provinceCode" defaultValue:@""];
        self.provinceName = [areaDic getStringValueForKey:@"provinceName" defaultValue:@""];
        self.cityCode = [areaDic getStringValueForKey:@"cityCode" defaultValue:@""];
        self.cityName = [areaDic getStringValueForKey:@"cityName" defaultValue:@""];
        self.districtCode = [areaDic getStringValueForKey:@"districtCode" defaultValue:@""];
        self.districtName = [areaDic getStringValueForKey:@"districtName" defaultValue:@""];
        self.detailAddress = [dict getStringValueForKey:@"detailAddress" defaultValue:@""];
        self.zipCode = [dict getStringValueForKey:@"zipCode" defaultValue:@""];
        self.idCardType = [dict getStringValueForKey:@"idCardType" defaultValue:@""];
        self.idCardNumber = [dict getStringValueForKey:@"idCardNumber" defaultValue:@""];
        self.qq = [dict getStringValueForKey:@"qq" defaultValue:@""];
        self.weixin = [dict getStringValueForKey:@"weixin" defaultValue:@""];
        self.sex = [dict getIntValueForKey:@"sex" defaultValue:0];
        self.useablePoints = [dict getIntValueForKey:@"useablePoints" defaultValue:0];
        self.useableExp = [dict getIntValueForKey:@"useableExp" defaultValue:0];
    }
    
    return self;
}

- (NSURL *)headImageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString*)locationAddress{
    NSString *address = @"";
    if (self.provinceName && self.provinceName.length > 0) {
        address = self.provinceName;
    }
    if (self.cityName && self.cityName.length > 0) {
        address = [NSString stringWithFormat:@"%@-%@", address, self.cityName];
    }
    if (self.districtName && self.districtName.length > 0) {
        address = [NSString stringWithFormat:@"%@-%@", address, self.districtName];
    }
    if (address.length == 0) {
        return @"未设置";
    }
    return address;
}

- (NSString*)idCardInfomation{
    NSArray *arr = @[@"身份证", @"军官证", @"护照"];
    if (!(self.idCardNumber && self.idCardNumber.length > 0)) {
        return @"未设置";
    }
    return [NSString stringWithFormat:@"%@:%@", arr[self.idCardType.intValue], self.idCardNumber];
}

- (NSString*)homeTelForPersonal{
    if (_homeTel.length == 0) {
        return @"未设置";
    }
    return _homeTel;
}

- (NSString*)mobileNumForBindPhone{
    if (_mobileNum && _mobileNum.length > 0) {
        return [NSString stringWithFormat:@"%@****%@", [_mobileNum substringToIndex:3], [_mobileNum substringFromIndex:7]];
    }
    return @"";
}

@end

//
//  JRCase.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRCase.h"

@implementation JRCase

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.likeCount = [dict getIntValueForKey:@"likeCount" defaultValue:0];
        self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0]; //same with member_id
        self.commentCount = [dict getIntValueForKey:@"commentCount" defaultValue:0];
        
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.desc = [dict getStringValueForKey:@"desc" defaultValue:@""];
        self.userType = [dict getStringValueForKey:@"userType" defaultValue:@""];
        self.memo = [dict getStringValueForKey:@"memo" defaultValue:@""];
        self.imageUrl = [dict getStringValueForKey:@"imageUrl" defaultValue:@""];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.projectId = [dict getStringValueForKey:@"projectId" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        
        self.isFav = [dict getBoolValueForKey:@"isFav" defaultValue:NO];
        self.isLike = [dict getBoolValueForKey:@"isLike" defaultValue:NO];
        
    }
    
    return self;
}

- (id)buildDetailWithDictionary:(NSDictionary *)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    self.neighbourhoods = [dict getStringValueForKey:@"neighbourhoods" defaultValue:@""];
    self.roomType = [dict getStringValueForKey:@"roomType" defaultValue:@""];
    self.tags = [dict getStringValueForKey:@"tags" defaultValue:@""];
    self.desc = [dict getStringValueForKey:@"description" defaultValue:@""];
    self.projectStyle = [dict getStringValueForKey:@"projectStyle" defaultValue:@""];
    self.houseArea = [dict getIntValueForKey:@"houseArea" defaultValue:0];
    self.projectPrice = [dict getIntValueForKey:@"projectPrice" defaultValue:0];
    self.detailImageList = [dict objectForKey:@"detailImageList"];
    
    NSDictionary *areaInfo = [dict objectForKey:@"areaInfo"];
    if (areaInfo && [areaInfo isKindOfClass:[NSDictionary class]]) {
        self.provinceCode = [areaInfo getStringValueForKey:@"provinceCode" defaultValue:@""];
        self.provinceName = [areaInfo getStringValueForKey:@"provinceName" defaultValue:@""];
        self.cityCode = [areaInfo getStringValueForKey:@"cityCode" defaultValue:@""];
        self.cityName = [areaInfo getStringValueForKey:@"cityName" defaultValue:@""];
        self.districtCode = [areaInfo getStringValueForKey:@"districtCode" defaultValue:@""];
        self.districtName = [areaInfo getStringValueForKey:@"districtName" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRCase *s = [[JRCase alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (NSURL *)imageURL{
    return [NSURL URLWithString:self.imageUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString *)styleString{
    NSDictionary *styles = @{@"mashup": @"混搭风格",
                             @"european": @"欧式风格",
                             @"chinese": @"中式风格",
                             @"newClassical": @"新古典风格",
                             @"eastSourthAsia": @"东南亚风格",
                             @"america": @"美式风格",
                             @"countryside": @"田园风格",
                             @"mediterranean": @"地中海风格",
                             @"modern": @"现代风格",
                             @"other": @"其他",
                             };
    NSString *style = [styles objectForKey:self.projectStyle];
    if (style && style.length > 0) {
        return style;
    }
    
    return @"其他";
}

@end

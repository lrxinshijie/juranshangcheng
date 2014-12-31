//
//  JRCase.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRCase.h"
#import "ShareView.h"

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
    self.stylesName = [dict getStringValueForKey:@"stylesName" defaultValue:@""];
    self.isAuth = [dict getBoolValueForKey:@"isAuth" defaultValue:NO];
    self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
    self.isFav = [dict getBoolValueForKey:@"isFavFlag" defaultValue:NO];
    self.isLike = [dict getBoolValueForKey:@"isLikeFlag" defaultValue:NO];
    
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

- (void)loadDetail:(void (^) (BOOL result))finished{
//    NSDictionary *param = @{@"projectId": self.projectId};
//    [[ALEngine shareEngine] pathURL:JR_PRODETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
//        if (!error) {
//            [self buildDetailWithDictionary:data];
//        }
//        finished(!error);
//    }];
    finished(YES);
}

- (void)like:(void (^) (BOOL result))finished{
    if (self.isLike) {
        if (finished) {
            finished(NO);
        }
        
        [Public alertOK:nil Message:@"已经点过赞"];
        return;
    }
    
    [[ALEngine shareEngine] pathURL:JR_GIVEALIKE parameters:@{@"projectId": self.projectId,@"projectType":@"1"} HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.isLike = YES;
            self.likeCount++;
        }
        if (finished) {
            finished(!error);
        }
        
    }];
}

- (void)favorite:(void (^) (BOOL result))finished{
    
    NSDictionary *param = @{@"projectId": self.projectId};
    if (!self.isFav) {
        param = @{@"projectId": self.projectId,
                  @"projectType": @"01"
                  };
    }
    [[ALEngine shareEngine] pathURL:self.isFav ? JR_CASE_UNFAVORITE : JR_CASE_FAVORITE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.isFav = !_isFav;
        }
        if (finished) {
            finished(!error);
        }
    }];
}

- (NSString *)shareURL{
    return [NSString stringWithFormat:@"http://apph5.juran.cn/cases/%@",self.projectId];
}

- (void)doShare{
    [[ShareView sharedView] showWithContent:self.desc image:[Public imageURLString:self.imageUrl] title:self.title url:self.shareURL];
}



@end

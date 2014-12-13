//
//  JRDesigner.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDesigner.h"
#import "JRCase.h"

@implementation JRDesigner

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }

        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.isRealNameAuth = [dict getIntValueForKey:@"isRealNameAuth" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.levelCode = [dict getStringValueForKey:@"levelCode" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
        self.styleNames = [dict getStringValueForKey:@"styleNames" defaultValue:@""];
        self.styleCodes = [dict getStringValueForKey:@"styleCodes" defaultValue:@""];
        self.selfIntroduction = [dict getStringValueForKey:@"selfIntroduction" defaultValue:@""];
        self.projectCount = [dict getIntValueForKey:@"projectCount" defaultValue:0];
        self.fansCount = [dict getIntValueForKey:@"fansCount" defaultValue:0];
        self.creditRateCount = [dict getIntValueForKey:@"creditRateCount" defaultValue:0];
        self.minisite = [dict getStringValueForKey:@"minisite" defaultValue:@""];
        self.experienceCount = [dict getIntValueForKey:@"experienceCount" defaultValue:0];
        self.browseCount = [dict getIntValueForKey:@"browseCount" defaultValue:0];
        NSString *urls = [dict getStringValueForKey:@"frontImgUrl"defaultValue:@""];
        if (urls.length == 0) {
            _frontImageUrlList = @[];
        }else{
            _frontImageUrlList = [urls componentsSeparatedByString:@","];

        }
    }
    
    return self;
}

- (id)buildDetailWithDictionary:(NSDictionary *)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
    self.userLevelName = [dict getStringValueForKey:@"userLevelName" defaultValue:@""];
    self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
    self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
    self.realName = [dict getStringValueForKey:@"realName" defaultValue:@""];
    self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
    self.isAuth = [dict getBoolValueForKey:@"isAuth" defaultValue:FALSE];
    self.granuate = [dict getStringValueForKey:@"granuate" defaultValue:@""];
    self.experience = [dict getIntValueForKey:@"experience" defaultValue:0];
    self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
    self.priceMeasure = [dict getIntValueForKey:@"priceMeasure" defaultValue:0];
    self.designFeeMin = [dict getIntValueForKey:@"designFeeMin" defaultValue:0];
    self.designFeeMax = [dict getIntValueForKey:@"designFeeMax" defaultValue:0];
    self.selfIntroduction = [dict getStringValueForKey:@"selfIntroduction" defaultValue:@""];
    self.product2DCount = [dict getIntValueForKey:@"product2DCount" defaultValue:0];
    self.product3DCount = [dict getIntValueForKey:@"product3DCount" defaultValue:0];
    self.followCount = [dict getIntValueForKey:@"followCount" defaultValue:0];
    self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0];
    self.isFollowed = [dict getBoolValueForKey:@"isFollowed" defaultValue:FALSE];
    self.followId = [dict getStringValueForKey:@"followId" defaultValue:@"0"];

    return self;
}

- (id)buildFollowDesignerWithDictionary:(NSDictionary *)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    self.followId = [dict getStringValueForKey:@"followId" defaultValue:@"0"];
    self.userId = [dict getIntValueForKey:@"followUserId" defaultValue:0];
    self.followUserId = [dict getStringValueForKey:@"userId" defaultValue:@""];
    self.remark = [dict getStringValueForKey:@"remark" defaultValue:@"0"];
    self.gmtCreate = [dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
    self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
    self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
    self.priceMeasure = [dict getIntValueForKey:@"priceMeasure" defaultValue:0];
    self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
    self.designFeeMin = [dict getIntValueForKey:@"designFeeMin" defaultValue:0];
    self.designFeeMax = [dict getIntValueForKey:@"designFeeMax" defaultValue:0];
    self.selfIntroduction = [dict getStringValueForKey:@"introduction" defaultValue:@""];
    self.weight = [dict getStringValueForKey:@"weight" defaultValue:@""];
    self.browseCount = [dict getIntValueForKey:@"browseCount" defaultValue:0];
    self.product2DCount = [dict getIntValueForKey:@"product2DCount" defaultValue:0];
    self.product3DCount = [dict getIntValueForKey:@"product3DCount" defaultValue:0];
    self.followCount = [dict getIntValueForKey:@"followCount" defaultValue:0];
    self.evaluationCount = [dict getStringValueForKey:@"evaluationCount" defaultValue:@""];
    self.tradeCount = [dict getStringValueForKey:@"tradeCount" defaultValue:@""];
    self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
    self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
    self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRDesigner *d = [[JRDesigner alloc] initWithDictionary:item];
            [retVal addObject:d];
        }
    }
    return retVal;
}

+ (NSMutableArray *)buildUpSearchDesignerWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    if ([value isKindOfClass:[NSDictionary class]]) {
        id designerList = value[@"designerList"];
        NSDictionary *frontImgDic = value[@"frontImgUrlMap"];
        NSDictionary *designExperienceDic = value[@"designExperience"];
        if ([designerList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in designerList) {
                JRDesigner *d = [[JRDesigner alloc] initWithDictionary:item];
                NSString *urls = [frontImgDic getStringValueForKey:[NSString stringWithFormat:@"%i", d.userId] defaultValue:@""];
                if (urls.length == 0) {
                    d.frontImageUrlList = @[];
                }else{
                    d.frontImageUrlList = [urls componentsSeparatedByString:@","];
                }
                d.experienceCount = [designExperienceDic getIntValueForKey:[NSString stringWithFormat:@"%i", d.userId] defaultValue:0];
                [retVal addObject:d];
            }
        }
        
    }
    return retVal;
}

+ (NSMutableArray *)buildUpFollowDesignerListWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    if ([value isKindOfClass:[NSDictionary class]]) {
        id designerList = value[@"designerList"];
        NSDictionary *frontImgDic = value[@"frontImgUrlMap"];
        NSDictionary *designExperienceDic = value[@"designExperience"];
        if ([designerList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in designerList) {
                JRDesigner *d = [[JRDesigner alloc] init];
                d = [d buildFollowDesignerWithDictionary:item];
                NSString *urls = [frontImgDic getStringValueForKey:[NSString stringWithFormat:@"%i", d.userId] defaultValue:@""];
                if (urls.length == 0) {
                    d.frontImageUrlList = @[];
                }else{
                    d.frontImageUrlList = [urls componentsSeparatedByString:@","];
                }
                d.experienceCount = [designExperienceDic getIntValueForKey:[NSString stringWithFormat:@"%i", d.userId] defaultValue:0];
                [retVal addObject:d];
            }
        }
        
    }
    return retVal;
}

- (NSURL *)imageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString*)styleNamesWithType:(NSInteger)type{
    //0 为设计师 1 为设计师详情
    NSArray *arr = [self.styleNames componentsSeparatedByString:@","];
    NSString* styleNames = @"";
    NSString* separateStr = type?@"、":@"｜";
    for (NSInteger i = 0; arr.count; i++) {
        styleNames = [styleNames stringByAppendingString:arr[i]];
        if (i == arr.count - 1) {
            break;
        }
        styleNames = [styleNames stringByAppendingString:separateStr];
    }
    return styleNames;
}

@end

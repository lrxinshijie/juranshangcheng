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

- (id)init{
    self = [super init];
    if (self) {
        self.headUrl = @"";
        self.account = @"";
        self.nickName = @"";
        self.userName = @"";
        self.selfIntroduction = @"";
        self.minisite = @"";
        self.frontImageUrlList = @[];
        
        self.userLevel = @"";
        self.userLevelName = @"";
        self.realName = @"";
        self.granuate = @"";
        self.style = @"";
        self.followId = @"";
        
        self.followUserId = @"";
        self.remark = @"";
        self.gmtCreate = @"";
        self.weight = @"";
        self.evaluationCount = @"";
        self.tradeCount = @"";
        self.realNameAuth = @"";
        
        self.handHeldIdPhoto = @"";
        self.idCardNum = @"";
        self.positiveIdPhoto = @"";
        self.backIdphoto = @"";
        self.realNameGmtCreate = @"";
        self.realAuditDesc = @"";
        self.realNameAuthStatus = -1;
        
        self.oldNickName = @"";
        self.nickNameChangeable = @"";
        self.birthday = @"";
        self.areaInfo = [[JRAreaInfo alloc] init];
        self.idCardType = @"";
        self.qq = @"";
        self.weixin = @"";
        self.special = @"";
        self.professional = @"";
        self.professionalType = @"";
        self.personalHonor = @"";
        self.detailAddress = @"";
        self.mobileNum = @"";
        self.email = @"";
        self.sex = @"";
        self.experienceCount = @"";
        self.faceToFace = @"";
        self.freeMeasure = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }

        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.isRealNameAuth = [dict getIntValueForKey:@"isRealNameAuth" defaultValue:0];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.realName = [dict getStringValueForKey:@"realName" defaultValue:@""];
        self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
        self.styleNames = [dict getStringValueForKey:@"styleNames" defaultValue:@""];
        self.selfIntroduction = [dict getStringValueForKey:@"selfIntroduction" defaultValue:@""];
        self.projectCount = [dict getIntValueForKey:@"projectCount" defaultValue:0];
        self.fansCount = [dict getIntValueForKey:@"fansCount" defaultValue:0];
        self.creditRateCount = [dict getIntValueForKey:@"creditRateCount" defaultValue:0];
        self.minisite = [dict getStringValueForKey:@"minisite" defaultValue:@""];
        NSInteger e = [dict getIntValueForKey:@"experienceCount" defaultValue:-1];
        self.experienceCount = e == -1?@"":[NSString stringWithFormat:@"%d", e];
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
    NSInteger e = [dict getIntValueForKey:@"experience" defaultValue:-1];
    self.experienceCount = e == -1?@"":[NSString stringWithFormat:@"%d", e];
    
    self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
    self.priceMeasure = [dict getDoubleValueForKey:@"priceMeasureStr" defaultValue:0.f];
    self.designFeeMin = [dict getDoubleValueForKey:@"chargeStandardMinStr" defaultValue:0.f];
    self.designFeeMax = [dict getDoubleValueForKey:@"chargeStandardMaxStr" defaultValue:0.f];
    self.selfIntroduction = [dict getStringValueForKey:@"selfIntroduction" defaultValue:@""];
    self.product2DCount = [dict getIntValueForKey:@"product2DCount" defaultValue:0];
    self.product3DCount = [dict getIntValueForKey:@"product3DCount" defaultValue:0];
    self.followCount = [dict getIntValueForKey:@"followCount" defaultValue:0];
    self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0];
    self.isFollowed = [dict getBoolValueForKey:@"isFollowed" defaultValue:FALSE];
    self.followId = [dict getStringValueForKey:@"followId" defaultValue:@"0"];
    NSInteger f = [dict getIntValueForKey:@"freeMeasure" defaultValue:-1];
    self.freeMeasure = f == -1?@"":[NSString stringWithFormat:@"%d", f];
    f = [dict getIntValueForKey:@"faceToFace" defaultValue:-1];
    self.faceToFace = f == -1?@"":[NSString stringWithFormat:@"%d", f];
    self.useablePoints = [dict getIntValueForKey:@"useablePoints" defaultValue:0];
    self.useableExp = [dict getIntValueForKey:@"useableExp" defaultValue:0];
    self.isEmailVali = [dict getIntValueForKey:@"isEmailVali" defaultValue:0];
    self.isMobileVali = [dict getIntValueForKey:@"isMobileVali" defaultValue:0];
    
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
                d.experienceCount = [designExperienceDic getStringValueForKey:[NSString stringWithFormat:@"%i", d.userId] defaultValue:@""];
                [retVal addObject:d];
            }
        }
        
    }
    return retVal;
}

+ (NSMutableArray *)buildUpFollowDesignerListWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    if ([value isKindOfClass:[NSDictionary class]]) {
        id designerList = value[@"designerSearchResDtoList"];
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
                d.experienceCount = [designExperienceDic getStringValueForKey:[NSString stringWithFormat:@"%i", d.userId] defaultValue:@""];
                [retVal addObject:d];
            }
        }
        
    }
    return retVal;
}

- (id)initWithDictionaryForBidInfo:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.userType = [dict getIntValueForKey:@"userType" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.isRealNameAuth = [dict getIntValueForKey:@"isRealNameAuth" defaultValue:0];
        self.styleNames = [dict getStringValueForKey:@"styleNames" defaultValue:@""];
        NSInteger e = [dict getIntValueForKey:@"experienceCount" defaultValue:-1];
        self.experienceCount = e == -1?@"":[NSString stringWithFormat:@"%d", e];
        self.browseCount = [dict getIntValueForKey:@"browseCount" defaultValue:0];
        self.projectCount = [dict getIntValueForKey:@"projectCount" defaultValue:0];
    }
    return self;
}

- (id)initWithDictionaryForRealNameAuth:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.handHeldIdPhoto = [dict getStringValueForKey:@"handHeldIdPhoto" defaultValue:@""];
        self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
        self.idCardNum = [dict getStringValueForKey:@"idCardNum" defaultValue:@""];
        self.positiveIdPhoto = [dict getStringValueForKey:@"positiveIdPhoto" defaultValue:@""];
         self.backIdphoto = [dict getStringValueForKey:@"backIdphoto" defaultValue:@""];
        self.realNameAuthId = [dict getIntValueForKey:@"id" defaultValue:0];
        self.realNameAuthStatus = [dict getIntValueForKey:@"status" defaultValue:-1];
        self.realNameGmtCreate = [dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
        self.realAuditDesc = [dict getStringValueForKey:@"auditDesc" defaultValue:@""];
    }
    return self;
}

- (NSString*)formatUserName{
    NSString *name = @"";
    if (_userName && _userName.length > 0) {
        name = _userName;
    }else if (_nickName && _nickName.length > 0){
        name = _nickName;
    }else{
        name = _account;
    }
    name = [Public formatString:name maxLength:12];
    return name;
}

- (NSURL *)imageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString*)styleNamesWithType:(NSInteger)type{
    //0 为设计师 1 为设计师详情
    NSArray *arr = [self.styleNames componentsSeparatedByString:@"，"];
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

- (NSString*)experienceString{
    if (_experienceCount.length == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@年", _experienceCount];
}

+ (NSString*)userLevelImage:(NSString*)userLevel{
    NSArray *levels = @[@"design_one", @"design_two", @"design_three", @"design_four", @"design_five"];
//    NSInteger index = 0;
//    for (NSString *s in levels) {
//        if ([s isEqualToString:userLevel]) {
//            break;
//        }
//        index++;
//    }
    
    NSInteger index = [levels containsObject:userLevel] ? [levels indexOfObject:userLevel] : 0;
    return [NSString stringWithFormat:@"userlevel%d", index];
}

- (NSString*)realNameAuthDescription{
    if (_realNameAuthStatus == 0) {
        return @"实名认证资料需3-5个工作日审核，请耐心等候！居然设计QQ群：124521444";
    }else if (_realNameAuthStatus == 1) {
        return [NSString stringWithFormat:@"很抱歉，您未通过审核，可提交信息重新申请！\n未通过原因:%@", _realAuditDesc];
    }else if (_realNameAuthStatus == 2) {
        return @"恭喜您已通过实名认证";
    }
    return @"";
}

- (NSString*)realNameAuthStatusString{
    if (_realNameAuthStatus == 0) {
        return @"信息审核中";
    }else if (_realNameAuthStatus == 1) {
        return @"信息审核未通过";
    }else if (_realNameAuthStatus == 2) {
        return @"信息审核通过";
    }
    return @"";
}

- (void)buildUpWithValueForPersonal:(id)value{
    if (!value || ![value isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    self.userLevel = [value getStringValueForKey:@"userLevel" defaultValue:@""];
    self.userLevelName  = [value getStringValueForKey:@"userLevelName " defaultValue:@""];
    self.userName = [value getStringValueForKey:@"realName" defaultValue:@""];
    self.headUrl = [value getStringValueForKey:@"headUrl" defaultValue:@""];
    self.account = [value getStringValueForKey:@"account" defaultValue:@""];
    self.isAuth = [value getBoolValueForKey:@"isAuth" defaultValue:FALSE];
    self.product2DCount = [value getIntValueForKey:@"product2DCount" defaultValue:0];
    self.product3DCount = [value getIntValueForKey:@"product3DCount" defaultValue:0];
    self.followCount = [value getIntValueForKey:@"followCount" defaultValue:0];
    self.viewCount = [value getIntValueForKey:@"viewCount" defaultValue:0];
    self.nickName = [value getStringValueForKey:@"nickName" defaultValue:@""];
    self.oldNickName = [value getStringValueForKey:@"oldNickName" defaultValue:@""];
    self.nickNameChangeable = [value getStringValueForKey:@"nickNameChangeable" defaultValue:@""];
    self.birthday = [value getStringValueForKey:@"birthday" defaultValue:@""];
    self.areaInfo = [[JRAreaInfo alloc] initWithDictionary:value[@"areaInfo"]];
    self.idCardType = [value getStringValueForKey:@"idCardType" defaultValue:@""];
    self.idCardNum = [value getStringValueForKey:@"idCardNum" defaultValue:@""];
    self.qq = [value getStringValueForKey:@"qq" defaultValue:@""];
    self.weixin = [value getStringValueForKey:@"weixin" defaultValue:@""];
    NSInteger s = [value getIntValueForKey:@"sex" defaultValue:-1];
    self.sex = s == -1?@"":[NSString stringWithFormat:@"%d", s];
    NSInteger e = [value getIntValueForKey:@"designExperience" defaultValue:-1];
    self.experienceCount = e == -1?@"":[NSString stringWithFormat:@"%d", e];
    NSInteger f = [value getIntValueForKey:@"freeMeasure" defaultValue:-1];
    self.freeMeasure =  f == -1?@"":[NSString stringWithFormat:@"%d", f];
    self.priceMeasure = [value getDoubleValueForKey:@"priceMeasureStr" defaultValue:0.f];
    self.style = [value getStringValueForKey:@"style" defaultValue:@""];
    self.special = [value getStringValueForKey:@"special" defaultValue:@""];
    self.granuate = [value getStringValueForKey:@"graduateInstitutions" defaultValue:@""];
    self.selfIntroduction = [value getStringValueForKey:@"selfIntroduction" defaultValue:@""];
    self.professional = [value getStringValueForKey:@"professional" defaultValue:@""];
    self.professionalType = [value getStringValueForKey:@"professionalType" defaultValue:@""];
    self.personalHonor = [value getStringValueForKey:@"personalHonor" defaultValue:@""];
    f = [value getIntValueForKey:@"faceToFace" defaultValue:-1];
    self.faceToFace = f == -1?@"":[NSString stringWithFormat:@"%d", f];
    self.designFeeMax = [value getDoubleValueForKey:@"chargeStandardMaxStr" defaultValue:0.f];
    self.designFeeMin = [value getDoubleValueForKey:@"chargeStandardMinStr" defaultValue:0.f];
    self.mobileNum = [value getStringValueForKey:@"mobileNum" defaultValue:@""];
    self.email = [value getStringValueForKey:@"email" defaultValue:@""];
}

- (NSString*)sexyString{
    if (self.sex.length == 0) {
        return @"未设置";
    }
    NSArray *sexs = [DefaultData sharedData].sex;
    NSDictionary *dic = sexs[[_sex integerValue]];
    return dic[@"k"];
}

- (NSString*)idCardInfomation{
    NSArray *arr = @[@"身份证", @"军官证", @"护照"];
    if (!(self.idCardNum && self.idCardNum.length > 0)) {
        return @"未设置";
    }
    if (self.idCardNum.length >= 10) {
        return [NSString stringWithFormat:@"%@:%@****%@", arr[self.idCardType.intValue], [self.idCardNum substringToIndex:5], [self.idCardNum substringFromIndex:_idCardNum.length - 2]];
    }
    
    return [NSString stringWithFormat:@"%@:%@", arr[self.idCardType.intValue], self.idCardNum];
    
}

- (NSString*)professionalTypeString{
    NSArray *professionalTypes = [[DefaultData sharedData] professionalType];
    for (NSDictionary *dic in professionalTypes) {
        if ([[dic objectForKey:@"v"] isEqualToString:_professionalType]) {
            return dic[@"k"];
        }
    }
    return @"未设置";
}


- (NSString*)styleNameForPersonal{
    NSArray *styles = [[DefaultData sharedData] style];
    NSArray *arr = [self.style componentsSeparatedByString:@","];
    NSString* styleNames = @"";
    NSInteger i = 0;
    for (NSString *str in arr) {
        if (str.length > 0) {
            for (NSDictionary *dic in styles) {
                if ([str isEqualToString:dic[@"v"]]) {
                    if(i != 0){
                        styleNames = [styleNames stringByAppendingString:@"|"];
                    }
                    styleNames = [styleNames stringByAppendingString:dic[@"k"]];
                }
            }
            i++;
        }
    }
    return styleNames;
}

- (NSString*)specialForPersonal{
    NSArray *specials = [[DefaultData sharedData] special];
    NSArray *arr = [self.special componentsSeparatedByString:@","];
    NSString* specialStr = @"";
    NSInteger i = 0;
    for (NSString *str in arr) {
        if (str.length > 0) {
            for (NSDictionary *dic in specials) {
                if ([str isEqualToString:dic[@"v"]]) {
                    if(i != 0){
                        specialStr = [specialStr stringByAppendingString:@"|"];
                    }
                    specialStr = [specialStr stringByAppendingString:dic[@"k"]];
                }
            }
            i++;
        }
    }
    return specialStr;
}

- (NSString*)measureForPersonal{
    if (self.freeMeasure.length == 0) {
        return @"未设置";
    }else if (self.freeMeasure.integerValue == 0) {
        return @"免费";
    }else{
        return [NSString stringWithFormat:@"%.2f元", _priceMeasure];
    }
}
- (NSString*)designPriceForPersonal{
    if (self.faceToFace.length == 0) {
        return @"未设置";
    }else if (self.faceToFace.integerValue == 0) {
        return @"面议";
    }else{
        return [NSString stringWithFormat:@"%.2f-%.2f 元/平方米", _designFeeMin, _designFeeMax];
    }
}


- (NSString*)mobileNumForBindPhone{
    if (_mobileNum.length == 11) {
        return [NSString stringWithFormat:@"%@****%@", [_mobileNum substringToIndex:3], [_mobileNum substringFromIndex:7]];
    }
    if (_mobileNum.length > 0) {
        return _mobileNum;
    }
    
    return @"未绑定";
}

- (NSString*)emailForBindEmail{
    NSString *mail = @"未绑定";
    if (!(_email.length > 0)) {
        return mail;
    }else{
        
        NSRange range = [_email rangeOfString:@"@"];
        if (range.length == 0) {
            return _email;
        }
        mail = [NSString stringWithFormat:@"%@****%@", [_email substringToIndex:range.location/4],[_email substringFromIndex:range.location/4*3]];
        return mail;
    }
}


@end

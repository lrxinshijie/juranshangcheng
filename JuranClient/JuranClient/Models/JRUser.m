//
//  JRUser.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRUser.h"
#import "JRAreaInfo.h"

#define kLocalUserData @"kLocalUserData"

@implementation JRUser

- (id)initWithDictionary:(NSDictionary*)dict{
    if (self=[self init]) {
        //用户信息
        self.guid = [dict getStringValueForKey:@"guid" defaultValue:@""];
        self.token = [dict getStringValueForKey:@"token" defaultValue:@""];
        self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
        self.userLevelName = [dict getStringValueForKey:@"userLevelName" defaultValue:@""];
        self.status = [dict getIntValueForKey:@"status" defaultValue:0];
        self.visitCount = [dict getIntValueForKey:@"visitCount" defaultValue:0];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.password = [dict getStringValueForKey:@"password" defaultValue:@""];
        self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];

    }
    return self;
}

+ (JRUser *)currentUser{
    static JRUser *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithLocal];
    });
    
    return sharedInstance;
}

- (instancetype)initWithLocal{
    if (self = [self init]) {
        NSDictionary *data = [self localUserData];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            self.account = [data getStringValueForKey:@"account" defaultValue:@""];
//            self.guid = [data getStringValueForKey:@"guid" defaultValue:@""];
            self.password = [data getStringValueForKey:@"password" defaultValue:@""];
//            self.token = [data getStringValueForKey:@"token" defaultValue:@""];
        }
    }
    
    return self;
}

- (void)resetCurrentUser{
//    JRUser *userInfo = [[JRUser alloc] initWithLocal];
    
    [JRUser currentUser].account = self.account;
    [JRUser currentUser].guid = self.guid;
    [JRUser currentUser].password = self.password;
    [JRUser currentUser].token = self.token;
}

- (void)saveLocal{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[self dictionary] forKey:kLocalUserData];
    [ud synchronize];
    //    [self resetCurrentUser];
}

- (NSDictionary *)dictionary{
    return @{@"account": [NSString stringWithFormat:@"%@",self.account],
//             @"guid": [NSString stringWithFormat:@"%@",self.guid],
             @"password": [NSString stringWithFormat:@"%@",self.password],
//             @"token": [NSString stringWithFormat:@"%@",self.token]
             };
}

- (NSDictionary *)localUserData{
    return [kUD objectForKey:kLocalUserData];
}

- (void)logout{
    JRUser *user = [[JRUser alloc] init];
    user.account = self.account;
    user.password = @"";
    user.guid = @"";
    user.token = @"";
    user.userId = 0;
    [user saveLocal];
    [user resetCurrentUser];
}

+ (BOOL)isLogin{
    return [JRUser currentUser].guid.length > 0;
}

+ (void)refreshToken:(VoidBlock)finished{
    
    NSString *account = [JRUser currentUser].account;
    NSString *password = [JRUser currentUser].password;
    if (account.length == 0 || password.length == 0) {
        return;
    }
    
    NSDictionary *param = @{@"account": account,
                            @"password": password};
    [[ALEngine shareEngine] pathURL:JR_LOGIN parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyShowErrorDefaultMessage:@"NO",kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            JRUser *user = [[JRUser alloc] initWithDictionary:data];
            user.account = account;
            user.password = password;
            [user saveLocal];
            [user resetCurrentUser];
            if (finished) {
                finished();
            }
        }else{
            [[JRUser currentUser] logout];
        }
    }];
}

- (void)buildUpProfileDataWithDictionary:(NSDictionary*)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
    self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
    self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
    self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
    self.hasNewBidCount = [dict getIntValueForKey:@"hasNewBigCount" defaultValue:0];
    self.newPrivateLetterCount = [dict getIntValueForKey:@"newPrivateLetterCount" defaultValue:0];
    self.newAnswerCount = [dict getIntValueForKey:@"newAnswerCount" defaultValue:0];
    self.newPushMsgCount = [dict getIntValueForKey:@"newPushMsgCount" defaultValue:0];
    self.isSigned = [dict getBoolValueForKey:@"isSigned" defaultValue:FALSE];
}

- (void)buildUpMemberDetailWithDictionary:(NSDictionary *)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    
    self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
    self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
    self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
    self.userName = [dict getStringValueForKey:@"userName" defaultValue:@""];
    self.mobileNum = [dict getStringValueForKey:@"mobileNum" defaultValue:@""];
    self.email = [dict getStringValueForKey:@"email" defaultValue:@""];
    self.birthday = [dict getStringValueForKey:@"birthday" defaultValue:@""];
    self.homeTel = [dict getStringValueForKey:@"homeTel" defaultValue:@""];
    NSDictionary *areaDic = dict[@"areaInfo"];
    self.areaInfo = [[JRAreaInfo alloc] initWithDictionary:areaDic];
    self.detailAddress = [dict getStringValueForKey:@"detailAddress" defaultValue:@""];
    self.zipCode = [dict getStringValueForKey:@"zipCode" defaultValue:@""];
    self.idCardType = [dict getStringValueForKey:@"idCardType" defaultValue:@""];
    self.idCardNumber = [dict getStringValueForKey:@"idCardNum" defaultValue:@""];
    self.qq = [dict getStringValueForKey:@"qq" defaultValue:@""];
    self.weixin = [dict getStringValueForKey:@"weixin" defaultValue:@""];
    self.sex = [dict getIntValueForKey:@"sex" defaultValue:0];
    self.useablePoints = [dict getIntValueForKey:@"useablePoints" defaultValue:0];
    self.useableExp = [dict getIntValueForKey:@"useableExp" defaultValue:0];
    self.accountChangeable = [dict getBoolValueForKey:@"accountChangeable" defaultValue:NO];
}

- (NSString*)locationAddress{
    NSString *address = @"";
    if (self.areaInfo.provinceName && self.areaInfo.provinceName.length > 0) {
        address = self.areaInfo.provinceName;
    }
    if (self.areaInfo.cityName && self.areaInfo.cityName.length > 0) {
        address = [NSString stringWithFormat:@"%@-%@", address, self.areaInfo.cityName];
    }
    if (self.areaInfo.districtName && self.areaInfo.districtName.length > 0) {
        address = [NSString stringWithFormat:@"%@-%@", address, self.areaInfo.districtName];
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
    if (self.idCardNumber.length >= 10) {
        return [NSString stringWithFormat:@"%@:%@****%@", arr[self.idCardType.intValue], [self.idCardNumber substringToIndex:5], [self.idCardNumber substringFromIndex:_idCardNumber.length - 2]];
    }
    
    return [NSString stringWithFormat:@"%@:%@", arr[self.idCardType.intValue], self.idCardNumber];
    
}

- (NSString*)homeTelForPersonal{
    if (_homeTel.length == 0) {
        return @"";
    }
    
    if (self.homeTel.length > 7) {
        return [NSString stringWithFormat:@"%@****%@", [_homeTel substringToIndex:3], [_homeTel substringFromIndex:7]];
    }
    
    return [NSString stringWithFormat:@"%@", _homeTel];
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

- (NSURL *)headImageURL{
    return [NSURL URLWithString:self.headUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString *)showName{
    
    if (self.userName.length > 0) {
        return self.userName;
    }
    
    if (self.nickName.length > 0) {
        return self.nickName;
    }
    
    return self.account;
}

@end

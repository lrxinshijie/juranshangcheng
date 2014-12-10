//
//  JRMemberDetail.h
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRAreaInfo;
@interface JRMemberDetail : NSObject

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *mobileNum;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *homeTel;
//@property (nonatomic, strong) NSString *provinceCode;
//@property (nonatomic, strong) NSString *provinceName;
//@property (nonatomic, strong) NSString *cityCode;
//@property (nonatomic, strong) NSString *cityName;
//@property (nonatomic, strong) NSString *districtCode;
//@property (nonatomic, strong) NSString *districtName;
@property (nonatomic, strong) JRAreaInfo *areaInfo;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *idCardType;
@property (nonatomic, strong) NSString *idCardNumber;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *weixin;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger useablePoints;
@property (nonatomic, assign) NSInteger useableExp;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSURL *)headImageURL;
- (NSString*)locationAddress;
- (NSString*)idCardInfomation;
- (NSString*)homeTelForPersonal;
- (NSString*)mobileNumForBindPhone;

@end

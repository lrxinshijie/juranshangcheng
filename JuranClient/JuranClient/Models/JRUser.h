//
//  JRUser.h
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JRAreaInfo;

@interface JRUser : NSObject

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userLevel;
@property (nonatomic, copy) NSString *userLevelName;
@property (nonatomic, assign) NSInteger visitCount;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userType;

//ProfileData
@property (nonatomic, assign) NSInteger hasNewBidCount;
@property (nonatomic, assign) NSInteger newPrivateLetterCount;
@property (nonatomic, assign) NSInteger newAnswerCount;
@property (nonatomic, assign) NSInteger newPushMsgCount;
@property (nonatomic, assign) BOOL isSigned;

//MemberDetail
@property (nonatomic, strong) NSString *mobileNum;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *homeTel;
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

+ (BOOL)isLogin;
- (void)logout;
- (NSDictionary *)localUserData;
- (void)saveLocal;
- (void)resetCurrentUser;
+ (JRUser *)currentUser;
- (id)initWithDictionary:(NSDictionary*)dict;
+ (void)refreshToken:(VoidBlock)finished;

//ProfileData
- (void)buildUpProfileDataWithDictionary:(NSDictionary*)dict;

//memberDetail
- (void)buildUpMemberDetailWithDictionary:(NSDictionary*)dict;
- (NSString*)locationAddress;
- (NSString*)idCardInfomation;
- (NSString*)homeTelForPersonal;
- (NSString*)mobileNumForBindPhone;
- (NSURL *)headImageURL;

- (NSString *)showName;
@end

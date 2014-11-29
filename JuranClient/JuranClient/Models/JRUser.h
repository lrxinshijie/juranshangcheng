//
//  JRUser.h
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRUser : NSObject

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userLevel;
@property (nonatomic, copy) NSString *userLevelName;
@property (nonatomic, assign) NSInteger visitCount;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userType;

+ (BOOL)isLogin;
- (void)logout;
- (NSDictionary *)localUserData;
- (void)saveLocal;
- (void)resetCurrentUser;
+ (JRUser *)currentUser;
- (id)initWithDictionary:(NSDictionary*)dict;
@end

//
//  JRUser.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRUser.h"

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
            self.guid = [data getStringValueForKey:@"guid" defaultValue:@""];
            self.password = [data getStringValueForKey:@"password" defaultValue:@""];
            self.token = [data getStringValueForKey:@"token" defaultValue:@""];
        }
    }
    
    return self;
}

- (void)resetCurrentUser{
    JRUser *userInfo = [[JRUser alloc] initWithLocal];
    
    [JRUser currentUser].account = userInfo.account;
    [JRUser currentUser].guid = userInfo.guid;
    [JRUser currentUser].password = userInfo.password;
    [JRUser currentUser].token = userInfo.token;
}

- (void)saveLocal{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[self dictionary] forKey:kLocalUserData];
    [ud synchronize];
    //    [self resetCurrentUser];
}

- (NSDictionary *)dictionary{
    return @{@"account": [NSString stringWithFormat:@"%@",self.account],
             @"guid": [NSString stringWithFormat:@"%@",self.guid],
             @"password": [NSString stringWithFormat:@"%@",self.password],
             @"token": [NSString stringWithFormat:@"%@",self.token]
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
    [user saveLocal];
    [user resetCurrentUser];
}

+ (BOOL)isLogin{
    return [JRUser currentUser].guid.length > 0;
}

@end

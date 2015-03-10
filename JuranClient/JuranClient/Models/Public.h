//
//  Public.h
//  Yousha
//
//  Created by System Administrator on 11-1-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define kDefaultCityNumber @"860515"
#define kDefaultCityName @"深圳"

@class JRAdInfo;

@interface Public : NSObject 
//简单的弹出窗
+ (void)alertOK:(NSString *)title Message:(NSString *)message;
+ (void)alertAndTime:(NSString *)msg Time:(double)time;

//手机号码
+ (NSString *)devicePhoneNumber;

//系统名称
+ (NSString *)deviceSystemName;

//系统版本 
+ (NSString *)deviceSystemVersion;

//设备ID deviceID
+ (NSString *)deviceUniqueIdentifier;

//设备(ipod touch  iphone   ipad)
+ (NSString *)deviceModel;

//设备名称
+ (NSString *)deviceName;

+ (NSString *)deviceToken;

//初始化应用
+ (void)initApp;

//应用版本
+ (NSString *)versionString;

//根据程序名获取图片
+ (UIImage *)imageWithName:(NSString *)aName ofType:(NSString *)ext;
+ (UIImage *)imageWithName:(NSString *)aName;

+ (UIFont *)fontWithTitle;
+ (UIColor *)mainColor;
+ (UIFont *)fontWithCover;
+ (UIFont *)fontWithSmall;

//常用字体
+ (UIFont *)fontWithContent;

+ (BOOL)versionEqualString:(NSString *)old_version NewVersion:(NSString *)new_version;

+ (UINavigationController *)navigationControllerFromRootViewController:(UIViewController *)viewController;

+ (NSString*)carrierName;
+ (NSString *)carrierCode;

+ (NSString *)md5FromData:(NSData *)data;

+ (BOOL)validateMobile:(NSString *)mobileNum;

+ (NSString *)encodeWithString:(NSString *)password;

+ (NSString *)googleLanguageFromLocal;
+ (NSString *)imageURLString:(NSString *)url;
+ (NSURL *)imageURL:(NSString *)url;
+ (NSURL *)imageURL:(NSString *)url Width:(NSInteger)width Height:(NSInteger)height Editing:(BOOL)editing;
+ (NSURL *)imageURL:(NSString *)url Width:(NSInteger)width;

//图片质量 0为普通 1为高质量
+ (NSNumber*)imageQuality;
+ (void)setImageQuality:(NSNumber*)number;

//图片质量智能模式 0为不是智能模式  1为智能模式
+ (NSNumber*)intelligentModeForImageQuality;
+ (void)setIntelligentModeForImageQuality:(NSNumber*)number;

//+ (NSArray*)searchHistorysWithSearchType:(SearchType)type;
//+ (void)addSearchHistory:(NSString*)keyword searchType:(SearchType)type;
//+ (void)removeAllSearchHistoryWithSearchType:(SearchType)type;
+ (NSArray*)searchHistorys;
+ (void)addSearchHistory:(NSString*)keyword;
+ (void)removeAllSearchHistory;

//计算中文字符的长度
+ (NSInteger)convertToInt:(NSString*)strtemp;
+ (NSString*)formatString:(NSString*)string maxLength:(NSInteger)maxLength;

+ (void)jumpFromLink:(NSString *)link;

+ (NSDictionary *)deviceInfo;

+ (BOOL)isDesignerApp;

+ (NSString *)shareEnv;

+ (BOOL)saveWelcomeInfo:(JRAdInfo*)info;
+ (JRAdInfo*)welcomeInfo;

@end

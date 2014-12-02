//
//  Public.m
//  Yousha
//
//  Created by System Administrator on 11-1-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Public.h"
#import "GlobalPopupAlert.h"
#import "zlib.h"
#import "AppDelegate.h"
#import <netdb.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSObject+ASCategory.h"
#import "NSString+ASCategory.h"
#import "UINavigationBar+ASCategory.h"

@implementation Public

+ (NSString *)imagePath{
	NSArray *searchPaths =
	NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
//	NSLog(@"image path:%@/photos", documentFolderPath);
	documentFolderPath = [NSString stringWithFormat:@"%@",documentFolderPath];
	return  documentFolderPath;
}

+ (void)alertAndTime:(NSString *)msg Time:(double)time{
    [GlobalPopupAlert show:msg andFadeOutAfter:time];
}

+ (void)alertOK:(NSString *)title Message:(NSString *)message{
//    if (title && ![title isEqualToString:@""]) {
//        [GlobalPopupAlert show:[NSString stringWithFormat:@"%@\n%@",title,message] andFadeOutAfter:1.5];
//    }else {
//        [GlobalPopupAlert show:message andFadeOutAfter:1.5];
//    }
    
    if (title && ![title isEqualToString:@""]) {
        [GlobalPopupAlert show:[NSString stringWithFormat:@"%@\n%@",title,message] andFadeOutAfter:1.5];
    }else {
        [GlobalPopupAlert show:message andFadeOutAfter:1.5];
    }
    
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
//													message:message 
//												   delegate:self 
//										  cancelButtonTitle:nil 
//										  otherButtonTitles: @"确定",nil];
//	[alert show];	
//	[alert release];
}


+ (NSString *)devicePhoneNumber{
	NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"];
	return phone;
}
+ (NSString *)deviceSystemName{
	return [[UIDevice currentDevice] systemName];
}
+ (NSString *)deviceSystemVersion{
	return [[UIDevice currentDevice] systemVersion];
}
+ (NSString *)deviceUniqueIdentifier{
    return @"";
//	return [[UIDevice currentDevice] uniqueIdentifier];
}
+ (NSString *)deviceModel{
	return [[UIDevice currentDevice] model];
}
+ (NSString *)deviceName{
	return [[UIDevice currentDevice] name];
}

+ (NSString *)deviceToken{
    return [kUD objectForKey:@"deviceToken"];
}

+ (void)initApp{
    
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *old_version = [NSString stringWithFormat:@"%@", [ud objectForKey:@"version"]];
    if ([Public versionEqualString:old_version NewVersion:[Public versionString]]) {    
        [ud setValue:[Public versionString] forKey:@"version"];
        
    }
    
	[ud synchronize];
}

+ (BOOL)versionEqualString:(NSString *)old_version NewVersion:(NSString *)new_version{
    
    
    ASLog(@"version:%@,%@",old_version,new_version);
    
    return [old_version compareToVersionString:new_version] == NSOrderedAscending;
    
    BOOL retVal = NO;
    
    if (old_version.length == 0) {
        return YES;
    }
    
    NSArray *new_arr = [new_version componentsSeparatedByString:@"."];
    NSArray *old_arr = [old_version componentsSeparatedByString:@"."];
    
    if (new_arr.count != old_arr.count) {
        return YES;
    }
    
    for (int i = 0; i<[new_arr count]; i++) {
        if ([[new_arr objectAtIndex:i] intValue] < [[old_arr objectAtIndex:i] intValue]) {
            break;
        }else if ([[new_arr objectAtIndex:i] intValue] > [[old_arr objectAtIndex:i] intValue]) {
            retVal = YES;
            break;
        }
    }
    
    return retVal;
}

+ (NSString *)versionString{
	NSString *file = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleVersion"]];
}

+ (UIImage *)imageWithName:(NSString *)aName{
    return [Public imageWithName:aName ofType:@"png"];
}

+ (UIImage *)imageWithName:(NSString *)aName ofType:(NSString *)ext{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:aName ofType:ext]];
}

+ (UIFont *)fontWithContent{
	return [UIFont systemFontOfSize:kSystemFontSize];
}

+ (UIFont *)fontWithSmall{
    return [UIFont systemFontOfSize:kSmallSystemFontSize-1];
}

+ (UIFont *)fontWithTitle{
	return [UIFont boldSystemFontOfSize:kASLabelFontSize];
}

+ (UIFont *)fontWithCover{
	return [UIFont boldSystemFontOfSize:20];
}

+ (UIColor *)mainColor{
    return [UIColor colorWithRed:128.0/255 green:177.0/255 blue:24.0/255 alpha:1];
}

+ (UINavigationController *)navigationControllerFromRootViewController:(UIViewController *)viewController{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navigationController.navigationBar setBackgroundImageWithColor:[UIColor whiteColor]];
//    if (SystemVersionGreaterThanOrEqualTo7) {
//        [navigationController.navigationBar setBackgroundImageWithColor:kNavigationBarBackgroundColor];
//        [navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
//    }
    
    return navigationController;
}

// 获取运营商名称
+ (NSString*)carrierName{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    
    NSString *carrierCode;
    if (carrier == nil) {
        carrierCode = @"None"; // 未取到，暂用None代替
    }else{
        carrierCode = [carrier carrierName];
    }
    return carrierCode;
}



// 获取运营商代号
+ (NSString *)carrierCode{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];

    NSString *carrierCode;
    
    if (carrier == nil) {
        carrierCode = @"";
        return carrierCode;
    }
    
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    carrierCode = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return carrierCode;
}

+ (NSString*)md5FromData:(NSData *)data{
    unsigned char result[16];
    CC_MD5( data.bytes, data.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
  * 验证手机号码
  **/
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    return mobileNum.length == 11;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)encodeWithString:(NSString *)password{
    const char* str = [password UTF8String];
    
    NSMutableString *result = [NSMutableString string];
    for(int i = 0; i<password.length; i++) {
        [result appendFormat:@"%c",str[i]^22333];
    }
    ASLog(@"ret:%@",result);
    return result;
}
+ (NSString *)getPreferredLanguage{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    //    ASLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

+ (NSString *)googleLanguageFromLocal{
    NSString *language = [Public getPreferredLanguage];
    if ([[language uppercaseString] isEqualToString:[@"zh-Hans" uppercaseString]]) {
        language = @"zh-CN";
    }else if ([[language uppercaseString] isEqualToString:[@"zh-Hant" uppercaseString]]) {
        language = @"zh-TW";
    }else{
        language = @"en";
    }
    return language;
}

+ (NSURL *)imageURL:(NSString *)url{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",JR_IMAGE_SERVICE,url];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)imageURL:(NSString *)url Width:(NSInteger)width Height:(NSInteger)height{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@_%d_%d.img",JR_IMAGE_SERVICE,url, width,height];
    return [NSURL URLWithString:urlString];
}

@end

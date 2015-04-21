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

#import "DesignerDetailViewController.h"
#import "JRDesigner.h"
#import "DesignerViewController.h"
#import "JRWebViewController.h"
#import "SubjectDetailViewController.h"
#import "JRSubject.h"
#import "JRPhotoScrollViewController.h"
#import "JRCase.h"
#import "CaseViewController.h"
#import "PushMessageViewController.h"
#import "PrivateMessageViewController.h"
#import "ALNavigationController.h"
#import "ActivityDetailViewController.h"
#import "WikiDetailViewController.h"
#import "WikiViewController.h"
#import "JRAdInfo.h"
#import "OrderDetailViewController.h"
#import "JROrder.h"
#import "RealNameAuthViewController.h"
#import "BidListViewController.h"
#import "NaviStoreListViewController.h"

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
    NSString *old_version = [ud objectForKey:@"version"];
    
    if (!old_version) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        old_version = @"";
    }
    
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
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
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
    ALNavigationController *navigationController = [[ALNavigationController alloc] initWithRootViewController:viewController];
    [navigationController.navigationBar setBackgroundImageWithColor:[UIColor whiteColor]];
//#ifdef kJuranDesigner
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//#endif
    
    if (SystemVersionGreaterThanOrEqualTo7) {
        [navigationController.navigationBar setBackgroundImageWithColor:[ALTheme sharedTheme].navigationColor];
        [navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [ALTheme sharedTheme].navigationTitleColor}];
    }
    
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

+ (NSString *)imageURLString:(NSString *)url{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",JR_IMAGE_SERVICE,url];
    return urlString;
}

+ (NSURL *)imageURL:(NSString *)url{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",JR_IMAGE_SERVICE,url];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)imageURL:(NSString *)url Width:(NSInteger)width Height:(NSInteger)height Editing:(BOOL)editing{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@_%d_%d%@.img",JR_IMAGE_SERVICE,url, width,height,editing?@"_1":@""];
    return [NSURL URLWithString:urlString];
}

+ (NSURL*)imageURL:(NSString *)url Width:(NSInteger)width{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@_%d_0.img",JR_IMAGE_SERVICE,url, width];
    NSLog(@"%@", urlString);
    return [NSURL URLWithString:urlString];
}

+ (NSNumber*)imageQuality{
    NSNumber *number = [kUD objectForKey:@"kImageQuality"];
    return number?number:@0;
}

+ (void)setImageQuality:(NSNumber*)number{
    [kUD setObject:number forKey:@"kImageQuality"];
    [kUD synchronize];
}

+ (NSNumber*)intelligentModeForImageQuality{
    NSNumber *number = [kUD objectForKey:@"kIntelligentModeForImageQuality"];
    return number?number:@1;
}

+ (void)setIntelligentModeForImageQuality:(NSNumber*)number{
    [kUD setObject:number forKey:@"kIntelligentModeForImageQuality"];
    [kUD synchronize];
}

+ (NSArray*)searchHistorys{
    id historys = [kUD objectForKey:@"keywordsForSearchHistory"];
    if (historys && [historys isKindOfClass:[NSArray class]]) {
        return (NSArray*)historys;
    }else{
        return @[];
    }
}

+ (void)addSearchHistory:(NSString*)keyword{
    NSMutableArray *historys = [NSMutableArray arrayWithArray:[self searchHistorys]];
    for (NSString *str in historys) {
        if ([str isEqualToString:keyword]) {
            return;
        }
    }
    [historys insertObject:keyword atIndex:0];
    [kUD setObject:historys forKey:@"keywordsForSearchHistory"];
    [kUD synchronize];
}

+ (void)removeAllSearchHistory{
    [kUD setObject:@[] forKey:@"keywordsForSearchHistory"];
    [kUD synchronize];
}

+ (NSInteger)convertToInt:(NSString*)strtemp{
    
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSString*)formatString:(NSString*)string maxLength:(NSInteger)maxLength{
    if (!string || maxLength < 2) {
        return @"";
    }
    NSString *value = string;
    NSInteger length = [Public convertToInt:value];
    if (length > maxLength) {
        NSInteger i = maxLength/2;
        do{
            value = [string substringToIndex:i];
            i++;
        }while ([Public convertToInt:value] < maxLength - 2);
        value = [NSString stringWithFormat:@"%@..", value];
    }
    return value;
}

/*
+ (NSArray*)searchHistorysWithSearchType:(SearchType)type{
    id historys = [kUD objectForKey:[NSString stringWithFormat:@"keywordsForSearchHistory%d", type]];
    if (historys && [historys isKindOfClass:[NSArray class]]) {
        return (NSArray*)historys;
    }else{
        return @[];
    }
}

+ (void)addSearchHistory:(NSString*)keyword searchType:(SearchType)type{
    NSMutableArray *historys = [NSMutableArray arrayWithArray:[self searchHistorysWithSearchType:type]];
    for (NSString *str in historys) {
        if ([str isEqualToString:keyword]) {
            return;
        }
    }
    [historys insertObject:keyword atIndex:0];
    [kUD setObject:historys forKey:[NSString stringWithFormat:@"keywordsForSearchHistory%d", type]];
    [kUD synchronize];
}

+ (void)removeAllSearchHistoryWithSearchType:(SearchType)type{
    [kUD setObject:@[] forKey:[NSString stringWithFormat:@"keywordsForSearchHistory%d", type]];
    [kUD synchronize];
}
*/

+ (void)jumpFromLink:(NSString *)link{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSArray *links = [link componentsSeparatedByString:@"&"];
    [links enumerateObjectsUsingBlock:^(NSString *link, NSUInteger idx, BOOL *stop) {
        NSArray *values = [link componentsSeparatedByString:@"="];
        if ([values count] == 2) {
            [param setObject:[values lastObject] forKey:[values firstObject]];
        }
    }];
    ASLog(@"param:%@",param);
    UINavigationController *navigationController = (UINavigationController *)ApplicationDelegate.tabBarController.selectedViewController;
    NSInteger type = [param getIntValueForKey:@"type" defaultValue:0];
    if (type == 2){
        if ([param.allKeys containsObject:@"id"]) {
            DesignerDetailViewController *dv = [[DesignerDetailViewController alloc] init];
            JRDesigner *designer = [[JRDesigner alloc] init];
            designer.userId = [param getIntValueForKey:@"id" defaultValue:0];
            dv.designer = designer;
            dv.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:dv animated:YES];
        }else{
            DesignerViewController *cv = [[DesignerViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:param];
            [filterData removeObjectForKey:@"type"];
            [filterData removeObjectForKey:@"isRealAuth"];
            cv.filterData = filterData;
            cv.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:cv animated:YES];
        }
    }else if (type == 7){
        JRWebViewController *wv = [[JRWebViewController alloc] init];
        wv.urlString = [param getStringValueForKey:@"url" defaultValue:@""];
        wv.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:wv animated:YES];
    }else if (type == 6){
        SubjectDetailViewController *sd = [[SubjectDetailViewController alloc] init];
        JRSubject *subject = [[JRSubject alloc] init];
        subject.key = [param getIntValueForKey:@"id" defaultValue:0];
        sd.subject = subject;
        sd.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:sd animated:YES];
    }else if (type == 3){
        if ([param.allKeys containsObject:@"id"]) {
            JRCase *jrCase = [[JRCase alloc] init];
            jrCase.projectId = [param getStringValueForKey:@"id" defaultValue:@""];
            JRPhotoScrollViewController *dv = [[JRPhotoScrollViewController alloc] initWithJRCase:jrCase andStartWithPhotoAtIndex:0];
            dv.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:dv animated:YES];
        }else{
            CaseViewController *cv = [[CaseViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:param];
            [filterData removeObjectForKey:@"type"];
            cv.filterData = filterData;
            cv.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:cv animated:YES];
        }
    }else if (type == 8){
        //消息列表
        PushMessageViewController *vc = [[PushMessageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }else if (type == 9){
        //私信列表
        PrivateMessageViewController *pv = [[PrivateMessageViewController alloc] init];
        pv.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:pv animated:YES];
    }else if (type == 4){
        if ([param.allKeys containsObject:@"id"]) {
            WikiDetailViewController *vc = [[WikiDetailViewController alloc] init];
            vc.wikiId = [param getStringValueForKey:@"id" defaultValue:@""];
            vc.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:vc animated:YES];
        }else{
            WikiViewController *vc = [[WikiViewController alloc] init];
            NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:[[DefaultData sharedData] objectForKey:@"wikiDefaultParam"]];
            [filterData addEntriesFromDictionary:param];
            vc.filterData  = filterData;
            vc.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:vc animated:YES];
        }
    }else if (type == 5){
        if ([param.allKeys containsObject:@"id"]) {
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
            vc.activityId = [param getStringValueForKey:@"id" defaultValue:@""];
            vc.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:vc animated:YES];
        }
    }else if (type == 10 && [param.allKeys containsObject:@"tid"]){
        OrderDetailViewController *od = [[OrderDetailViewController alloc] init];
        NSInteger tradeType = [param getIntValueForKey:@"tradeType" defaultValue:0];
        
        JROrder *order = [[JROrder alloc] init];
        order.measureTid = [param getStringValueForKey:@"tid" defaultValue:@""];
        order.type = tradeType - 1;
        od.order = order;
        od.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:od animated:YES];
    }else if (type == 11){
        RealNameAuthViewController *rn = [[RealNameAuthViewController alloc] init];
        rn.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:rn animated:YES];
    }else if (type == 12){
        BidListViewController *vc = [[BidListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }else if (type == 19){
        NaviStoreListViewController *vc = [[NaviStoreListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    
}

+ (NSDictionary *)deviceInfo{
    return  @{@"appType":@"iphone",@"version":@"1.0",@"deviceType":@"iphone",@"osVersion":@"8.0"};
}

+ (BOOL)isDesignerApp{
//    NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    return ![bundleIdentifier isEqualToString:@"com.juran.JuranHome"];
    
#ifdef kJuranDesigner
    return YES;
#endif
    
    return NO;
}

+ (NSString *)shareEnv{
    if ([JR_SERVICE isEqualToString:@"http://54.223.161.28:8080"]) {
        return @"?env=uat";
    }else if ([JR_SERVICE isEqualToString:@"http://124.207.66.50:10005"]){
        return @"?env=dev";
    }else{
        return @"";
    }
}

+ (BOOL)saveWelcomeInfo:(JRAdInfo*)info{
    NSData *d = [kUD objectForKey:@"kWelcomeInfo"];
    if (d) {
        JRAdInfo *oldInfo = [NSKeyedUnarchiver unarchiveObjectWithData:d];;
        if (info.adId == oldInfo.adId) {
            return NO;
        }
    }
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:info];
    [kUD setObject:newData forKey:@"kWelcomeInfo"];
    [kUD synchronize];
    return YES;
}
+ (JRAdInfo*)welcomeInfo{
    NSData *data = [kUD objectForKey:@"kWelcomeInfo"];
    if (data) {
        JRAdInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return info;
    }
    return nil;
}

+ (void)clearWelcomeInfo{
    [kUD removeObjectForKey:@"kWelcomeInfo"];
}

+ (NSString *)defaultCityName{
    return @"北京市";
}

@end

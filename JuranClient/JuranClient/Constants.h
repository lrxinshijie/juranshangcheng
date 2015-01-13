
//  Constants.h
//  Flipboard
//
//  Created by Kowloon on 12-7-10.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#ifndef Flipboard_Constants_h
#define Flipboard_Constants_h

#define kWindowHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define kWindowHeightWithoutNavigationBar (kWindowHeight - 44)
#define kWindowHeightWithoutNavigationBarAndTabbar (kWindowHeightWithoutNavigationBar - 49)
#define kWindowWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kContentFrameWithoutNavigationBar CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), kWindowHeightWithoutNavigationBar)

#define kContentFrameWithoutNavigationBarAndTabBar CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), kWindowHeightWithoutNavigationBarAndTabbar)

#define kContentFrame CGRectMake(0, 0, kWindowWidth, SystemVersionGreaterThanOrEqualTo7 ? (kWindowHeight + 20) : kWindowHeight)

#define kViewBackgroundColor [UIColor whiteColor]
#define kTabBarBackgroundColor RGBColor(25, 25, 25)

#define kUD [NSUserDefaults standardUserDefaults]

#define kNavigationBarBackgroundColor kTabBarBackgroundColor

#define CELLDICTIONARYBUILT(a,b) @{@"k":a,@"v":b}

#define kContentBackgroundColor  [UIColor colorWithRed:234.0/255 green:247.0/255 blue:252.0/255 alpha:1]
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define UMENG_KEY @"53a7cf7f56240bbe65195bfd"
#define kAppleID 954983948

#define kAppURL [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8",kAppleID]
//#define kImageBackgroundColor RGBColor(242, 242, 242)
#define kImageBackgroundColor [UIColor grayColor]

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kNotificationNameProfileReloadData @"kNotificationNameProfileReloadData"
#define kNotificationNameFriendReloadData @"kNotificationNameFriendReloadData"
#define kNotificationNamePhotosReloadData @"kNotificationNamePhotosReloadData"
#define kNotificationNameAlbumDetailReloadData @"kNotificationNameAlbumDetailReloadData"
#define kNotificationNameNewsfeedReloadData @"kNotificationNameNewsfeedReloadData"
#define kNotificationNameNewsfeedDetailReloadData @"kNotificationNameNewsfeedDetailReloadData"
#define kNotificationNameCalendarReloadData @"kNotificationNameCalendarReloadData"
#define kNotificationNameEventReloadData @"kNotificationNameEventReloadData"
#define kNotificationNameMyDemandReloadData @"kNotificationNameMyDemandReloadData"

#define kBlueColor RGBColor(15, 82, 167)
//:@"100543115"8
//appSecret:@"9cc782277d5b8084f073599d72ba08c3"
#define QQHLSDKAppKey @"100543115"
#define QQHLSDKAppSecret @"9cc782277d5b8084f073599d72ba08c3"

#define kPasswordMaxNumber 20
#define kAccountMaxNumber 24
#define kPhoneMaxNumber 11
#define kCodeMaxNumber 6

#define kOnePageCount @"10"

typedef void (^BOOLBlock)(BOOL result);
typedef void (^VoidBlock)(void);

typedef enum : NSUInteger {
    FilterViewTypeCase,
    FilterViewTypeDesigner,
    FilterViewTypeDesignerSearch,
    FilterViewTypeCaseSearch,
    FilterViewTypeBidInfo,
} FilterViewType;

typedef enum : NSUInteger {
    FilterViewActionSort,
    FilterViewActionFilter,
    FilterViewActionGrid,
} FilterViewAction;

typedef enum : NSUInteger {
    SearchTypeDesigner = 0,
    SearchTypeCase,
    SearchTypeQuestion,
} SearchType;

//Share SDK
#define kShareSDKKey @"477b2576a9ca"

//新浪微博
#define kShareSinaWeiboKey @"974550530"
#define kShareSinaWeiboSecret @"b6acbd20f461a9c83be83e90aacf8ffb"
#define kShareSinaWeiboRedirectUri @"http://www.juran.cn"

//腾讯微博
#define kShareTencentWeiboKey @"801555309"
#define kShareTencentWeiboSecret @"71fd14ea4456a3bf906817e8bbefbdbd"
#define kShareTencentWeiboRedirectUri @"http://www.juran.cn"

//QQ互联
#define kShareQZoneKey @"1103839607"
#define kShareQZoneSecret @"B4DwT98l9vD3oHnB"

//微信
#define kShareWeChatKey @"wx3e32aa05bb32f554"
#define kShareWeChatSecret @"f2c0d5958e633bdee9c25c33bb4e913c"

//#ifdef kJuranDesigner
//
//#else
//
//#endif

#endif

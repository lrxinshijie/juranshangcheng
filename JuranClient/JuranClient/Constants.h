
//  Constants.h
//  Flipboard
//
//  Created by Kowloon on 12-7-10.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#ifndef Flipboard_Constants_h
#define Flipboard_Constants_h

/*****************by lsj**********************/
#define changeHeight   2
//RGB转换
#define UIColorFromHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

/*******************by custom************************/
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

#ifdef kJuranDesigner
#define kAppleID 954983948
#else
#define kAppleID 954983948
#endif

#ifndef kJuranVersion12
#define kJuranVersion12
#endif

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
#define kNotificationNameQuestionReloadData @"kNotificationNameQuestionReloadData"
#define kNotificationNameProudctPriceReloadData @"kNotificationNameProudctPriceReloadData"

#define kNotificationNameOrderReloadData @"kNotificationNameOrderReloadData"
#define kNotificationNameOrderPaySuccess @"kNotificationNameOrderPaySuccess"

#define kNotificationNameAttributeRowReload @"kNotificationNameAttributeRowReload"

#define kNotificationNameAttributeReloadData @"kNotificationNameAttributeReloadData"
#define kNotificationNameMsgCenterReloadData @"kNotificationNameMsgCenterReloadData"

#define kBlueColor RGBColor(15, 82, 167)

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
    FilterViewTypeWiki,
    FilterViewTypeCaseWithoutGrid,
    FilterViewTypeProduct
} FilterViewType;

typedef enum : NSUInteger {
    FilterViewActionSort,
    FilterViewActionFilter,
    FilterViewActionGrid,
    FilterViewActionStore
} FilterViewAction;

typedef enum : NSUInteger {
    SearchTypeCase = 0,
    SearchTypeDesigner,
    SearchTypeQuestion,
    SearchTypeGoods,
    SearchTypeShop,
} SearchType;

#endif

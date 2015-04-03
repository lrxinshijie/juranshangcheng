//
//  AppDelegate.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AppDelegate.h"
#import "CaseViewController.h"
#import "DesignerViewController.h"
#import "ProfileViewController.h"
#import "PublishDesignViewController.h"
#import "SubjectViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/QZoneConnection.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "GuideViewController.h"
#import "HomeViewController.h"
#import "UIAlertView+Blocks.h"
#import "WikiOrActivityViewController.h"
#import "APService.h"
#import "MobClick.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WelcomeView.h"
#import "IQKeyboardManager.h"
#import "WXApi.h"
#import "DeviceHardware.h"

//Share SDK
#define kShareSDKKey @"477b2576a9ca"

#ifdef kJuranDesigner

//新浪微博
#define kShareSinaWeiboKey @"1808654070"
#define kShareSinaWeiboSecret @"18664b6d7be4e3decf0135bd770b44ce"
#define kShareSinaWeiboRedirectUri @"http://www.juran.cn"

//腾讯微博
#define kShareTencentWeiboKey @"801557599"
#define kShareTencentWeiboSecret @"4543e45261590bf811ed90403fe7219a"
#define kShareTencentWeiboRedirectUri @"http://www.juran.cn"

//QQ互联
#define kShareQZoneKey @"1103999165"
#define kShareQZoneSecret @"RhagoumHovdjghAL"

//微信
#define kShareWeChatKey @"wx338441f4726af98d"
#define kShareWeChatSecret @"599f3a84d5377b1a1848ebf2c7515330"

//设计师生产
//#define kUMengKey @"55103068fd98c5b947000817"

//UAT
#define kUMengKey @"5511194bfd98c5e1e2000283"

#else

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
//#define kShareQZoneKey @"100570502"
//#define kShareQZoneSecret @"132432a6a38a4f2985de974ded313c2f"


//微信
#define kShareWeChatKey @"wx3e32aa05bb32f554"
#define kShareWeChatSecret @"f2c0d5958e633bdee9c25c33bb4e913c"

//消费者生产
//#define kUMengKey @"55102ebbfd98c5148a000182"

//UAT
#define kUMengKey @"5511191dfd98c576640005fe"


#endif


@interface AppDelegate () <UINavigationControllerDelegate, WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifndef kJuranDesigner
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    [Public initApp];
    
    self.clientId = @"";
    
    [MobClick startWithAppkey:kUMengKey];
    [MobClick updateOnlineConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupShareSDK];

    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ASLog(@"registrationID:%@",[APService registrationID]);
        [JRUser refreshToken:^{
            NSDictionary *param = @{@"imei": [APService registrationID],
                                    @"mac": @"",
                                    @"model": [Public deviceModel],
                                    @"dpi": [NSString stringWithFormat:@"%dx%d", (int)[DeviceHardware deviceWidth], (int)[DeviceHardware deviceHeight]],
                                    @"sysVersion": [Public deviceSystemVersion],
                                    @"token": [JRUser currentUser].token,
                                    @"userId": [NSString stringWithFormat:@"%d", [JRUser currentUser].userId],
                                    @"appVersion": [NSString stringWithFormat:@"%@|%@", [Public isDesignerApp] ? @"designer" : @"member", [self bundleVersion] ],
                                    @"createTimes": [[NSDate date] stringWithFormat:kDateFormatHorizontalLineLong]};
            ASLog(@"Log:%@",param);
            [[ALEngine shareEngine] pathURL:JR_START_LOG parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyShowErrorDefaultMessage:@(NO), kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
                if (error) {
                    ASLog(@"err:%@",error);
                }
            }];
        }];
    });
    
    [self jumpToMain];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)networkDidLogin:(NSNotification *)notification{
    self.clientId = [APService registrationID];
}

- (void)jumpToMain{
    if ([GuideViewController showGuide]) {
        GuideViewController *gv = [[GuideViewController alloc] init];
        gv.isHome = YES;
        self.window.rootViewController = gv;
    }else{
        [self setupTabbar];
    }
    if ([WelcomeView isShowView]) {
        WelcomeView *view = [[WelcomeView alloc] init];
        [_tabBarController.view addSubview:view];
        [view show];
    }
    [WelcomeView fecthData];
}

- (UITabBarItem *)setupTabbarItemTitle:(NSString *)title image:(NSString *)image selected:(NSString *)imageSel{
    UIImage *caseImage = [UIImage imageNamed:image];
    UIImage *caseImageSel = [UIImage imageNamed:imageSel];
    caseImage = [caseImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    caseImageSel = [caseImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UITabBarItem alloc] initWithTitle:title image:caseImage selectedImage:caseImageSel];
}

#ifdef kJuranDesigner
- (void)setupTabbar{
    CGFloat top = 6;
    HomeViewController *home = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [Public navigationControllerFromRootViewController:home];
    homeNav.tabBarItem = [self setupTabbarItemTitle:@"" image:@"nav-home-default" selected:@"nav-home-active"];
    [homeNav.tabBarItem setImageInsets:UIEdgeInsetsMake(top, 0, -top, 0)];
//    homeNav.delegate = self;
    
    CaseViewController *cs = [[CaseViewController alloc] init];
    cs.isHome = YES;
    UINavigationController *csNav = [Public navigationControllerFromRootViewController:cs];
    csNav.tabBarItem = [self setupTabbarItemTitle:@"" image:@"nav-case-default" selected:@"nav-case-active"];
    [csNav.tabBarItem setImageInsets:UIEdgeInsetsMake(top, 0, -top, 0)];
//    csNav.delegate = self;
    
    DesignerViewController *des = [[DesignerViewController alloc] init];
    des.isHome = YES;
    UINavigationController *desNav = [Public navigationControllerFromRootViewController:des];
    desNav.tabBarItem = [self setupTabbarItemTitle:@"" image:@"nav-designer-default" selected:@"nav-designer-active"];
    [desNav.tabBarItem setImageInsets:UIEdgeInsetsMake(top, 0, -top, 0)];
//    desNav.delegate = self;
    
    WikiOrActivityViewController *wiki = [[WikiOrActivityViewController alloc] init];
    UINavigationController *wikiNav = [Public navigationControllerFromRootViewController:wiki];
    wikiNav.tabBarItem = [self setupTabbarItemTitle:@"" image:@"nav-wiki-default" selected:@"nav-wiki-active"];
    [wikiNav.tabBarItem setImageInsets:UIEdgeInsetsMake(top, 0, -top, 0)];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    UINavigationController *profileNav = [Public navigationControllerFromRootViewController:profile];
    profileNav.tabBarItem = [self setupTabbarItemTitle:@"" image:@"nav-user-default" selected:@"nav-user-active"];
    [profileNav.tabBarItem setImageInsets:UIEdgeInsetsMake(top, 0, -top, 0)];
//    profileNav.delegate = self;
    
    self.tabBarController = [[UITabBarController alloc] init];
    UIImage *image = [UIImage imageFromColor:[UIColor blackColor]];
    [_tabBarController.tabBar setBackgroundImage:image];
    
    _tabBarController.viewControllers = @[homeNav,csNav,desNav,wikiNav,profileNav];
    self.window.rootViewController = _tabBarController;
    
//    self.tabBarController = [[LeveyTabBarController alloc] initWithViewControllers:@[homeNav,csNav,desNav,profileNav]];
//    [_tabBarController.tabBar setBackgroundImage:[UIImage imageFromColor:[[ALTheme sharedTheme] navigationColor]]];
//    [_tabBarController setTabBarTransparent:YES];
//    
//    self.window.rootViewController = _tabBarController;
    
    
}
#else

- (void)setupTabbar{
    CaseViewController *cs = [[CaseViewController alloc] init];
    cs.isHome = YES;
    UINavigationController *csNav = [Public navigationControllerFromRootViewController:cs];
    csNav.tabBarItem = [self setupTabbarItemTitle:@"案例" image:@"tabbar_case" selected:@"tabbar_case_hl"];
    
    DesignerViewController *des = [[DesignerViewController alloc] init];
    des.isHome = YES;
    UINavigationController *desNav = [Public navigationControllerFromRootViewController:des];
    desNav.tabBarItem = [self setupTabbarItemTitle:@"设计师" image:@"tabbar_designer" selected:@"tabbar_designer_hl"];
    
    SubjectViewController *topic = [[SubjectViewController alloc] init];
    UINavigationController *topicNav = [Public navigationControllerFromRootViewController:topic];
    topicNav.tabBarItem = [self setupTabbarItemTitle:@"专题" image:@"tabbar_subject" selected:@"tabbar_subject_hl"];
    
    PublishDesignViewController *publish = [[PublishDesignViewController alloc] init];
    UINavigationController *publishNav = [Public navigationControllerFromRootViewController:publish];
    publishNav.tabBarItem = [self setupTabbarItemTitle:@"发布需求" image:@"tabbar_demands" selected:@"tabbar_demands_hl"];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    UINavigationController *profileNav = [Public navigationControllerFromRootViewController:profile];
    profileNav.tabBarItem = [self setupTabbarItemTitle:@"个人中心" image:@"tabbar_personal" selected:@"tabbar_personal_hl"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[csNav,topicNav,publishNav,desNav,profileNav];
    self.window.rootViewController = _tabBarController;
}
#endif

- (void)setupShareSDK{

    [ShareSDK registerApp:kShareSDKKey];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"4218949951"
//                               appSecret:@"444121dbfb4e449ba7caf573b617652c"
//                             redirectUri:@"http://demo.juran.cn/member/sinalogin.htm"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:kShareSinaWeiboKey
                                appSecret:kShareSinaWeiboSecret
                              redirectUri:kShareSinaWeiboRedirectUri
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:kShareTencentWeiboKey
                                  appSecret:kShareTencentWeiboSecret
                                redirectUri:kShareTencentWeiboRedirectUri
                                   wbApiCls:[WeiboApi class]];
//    [ShareSDK connect163WeiboWithAppKey:@"9F2EiRMl1VxVMEtj"
//                              appSecret:@"iWxz6yHnT5xexD04hDIKnjUihlvNq3co"
//                            redirectUri:@"http://www.juran.cn/member/nteslogin.htm"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:kShareQZoneKey
                           appSecret:kShareQZoneSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:kShareQZoneKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:@"wx3e32aa05bb32f554"
//                           wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatFavWithAppId:@"wx3e32aa05bb32f554" appSecret:@"f2c0d5958e633bdee9c25c33bb4e913c" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:kShareWeChatKey
                           appSecret:kShareWeChatSecret
                           wechatCls:[WXApi class]];
    
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self clearNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strTitle = @"";
        
        switch (resp.errCode) {
            case WXSuccess:
                strTitle = @"支付成功";
                break;
            case WXErrCodeUserCancel:
                strTitle = @"用户中途取消";
                break;
            default:
                strTitle = resp.errStr;
                break;
        }
        
        [Public alertOK:nil Message:strTitle];
        
        if (resp.errCode == WXSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderPaySuccess object:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        ASLog(@"url:%@", url);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             ASLog(@"result = %@",resultDic);
//                                             NSString *resultStr = resultDic[@"result"];
                                             NSInteger resultStatus = [resultDic getIntValueForKey:@"resultStatus" defaultValue:0];
                                             
                                             NSDictionary *tips = @{@"9000": @"支付成功",
                                                                    @"8000": @"订单支付成功",
                                                                    @"4000": @"订单支付失败",
                                                                    @"6001": @"用户中途取消",
                                                                    @"6002": @"网络连接出错"
                                                                    };
                                             NSString *tip = [tips getStringValueForKey:[NSString stringWithFormat:@"%d", resultStatus] defaultValue:@""];
                                             if (tip.length > 0) {
                                                 [Public alertOK:nil Message:tip];
                                             }
                                             if (resultStatus == 9000) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameOrderPaySuccess object:nil];
                                             }
                                         }];
        
    }else if ([url.host isEqualToString:@"pay"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - Push

- (void)showAPNS:(NSDictionary *)userInfo{
    ASLog(@"APNS:%@",userInfo);
    
    [APService handleRemoteNotification:userInfo];
    
    [self clearNotification];
    
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

    NSInteger type = [userInfo getIntValueForKey:@"type" defaultValue:0];
    
    if (type == 2) {
        NSString *link = [userInfo getStringValueForKey:@"link" defaultValue:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProfileReloadData object:nil];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [Public jumpFromLink:link];
            });
        }else{
            [UIAlertView showWithTitle:nil message:alert cancelButtonTitle:@"取消" otherButtonTitles:@[@"查看"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == [alertView cancelButtonIndex]) {
                    return ;
                }
                [Public jumpFromLink:link];
            }];
        }
    }else{
        [UIAlertView showWithTitle:nil message:alert cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    [APService registerDeviceToken:deviceToken];
    
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    NSString *dToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    ASLog(@"deviceToken:%@", dToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self showAPNS:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    
    [self showAPNS:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)clearNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [self minusBadgeNumber:1];
}

- (void)minusBadgeNumber:(NSInteger)num{
    [UIApplication sharedApplication].applicationIconBadgeNumber -= num;
}

@end

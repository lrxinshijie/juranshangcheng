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
#import "GexinSdk.h"
#import "UIAlertView+Blocks.h"

#define kAppId           @"ZmiyzZ23sKAvFQ7RoAfbJ2"
#define kAppKey          @"kJRhD2minf7dJ6CK5u43o6"
#define kAppSecret       @"u1p1T7GV0e54W1DALv03c1"


@interface AppDelegate () <UINavigationControllerDelegate, GexinSdkDelegate>

@property (strong, nonatomic) GexinSdk *gexinPusher;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.clientId = @"";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupShareSDK];
    
    [self setupPush];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JRUser refreshToken:nil];
    });
    
    
    [self jumpToMain];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)jumpToMain{
    if ([GuideViewController showGuide]) {
        GuideViewController *gv = [[GuideViewController alloc] init];
        self.window.rootViewController = gv;
    }else{
        [self setupTabbar];
    }
}

- (UITabBarItem *)setupTabbarItemTitle:(NSString *)title image:(NSString *)image selected:(NSString *)imageSel{
    UIImage *caseImage = [UIImage imageNamed:image];
    UIImage *caseImageSel = [UIImage imageNamed:imageSel];
    caseImage = [caseImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    caseImageSel = [caseImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UITabBarItem alloc] initWithTitle:title image:caseImage selectedImage:caseImageSel];
}

- (void)setupTabbar{
#ifndef kJuranDesigner
    CaseViewController *cs = [[CaseViewController alloc] init];
    cs.isHome = YES;
#else
    HomeViewController *cs = [[HomeViewController alloc] init];
#endif
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

- (void)setupShareSDK{

    [ShareSDK registerApp:@"477b2576a9ca"];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"4218949951"
//                               appSecret:@"444121dbfb4e449ba7caf573b617652c"
//                             redirectUri:@"http://demo.juran.cn/member/sinalogin.htm"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"974550530"
                                appSecret:@"b6acbd20f461a9c83be83e90aacf8ffb"
                              redirectUri:@"http://www.juran.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801555309"
                                  appSecret:@"71fd14ea4456a3bf906817e8bbefbdbd"
                                redirectUri:@"http://www.juran.cn"
                                   wbApiCls:[WeiboApi class]];
//    [ShareSDK connect163WeiboWithAppKey:@"9F2EiRMl1VxVMEtj"
//                              appSecret:@"iWxz6yHnT5xexD04hDIKnjUihlvNq3co"
//                            redirectUri:@"http://www.juran.cn/member/nteslogin.htm"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1103839607"
                           appSecret:@"B4DwT98l9vD3oHnB"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1103839607"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:@"wx3e32aa05bb32f554"
//                           wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatFavWithAppId:@"wx3e32aa05bb32f554" appSecret:@"f2c0d5958e633bdee9c25c33bb4e913c" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx3e32aa05bb32f554"
                           appSecret:@"f2c0d5958e633bdee9c25c33bb4e913c"
                           wechatCls:[WXApi class]];
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (viewController.hidesBottomBarWhenPushed){
//        [_tabBarController hidesTabBar:YES animated:YES];
//    }else{
//        [_tabBarController hidesTabBar:NO animated:YES];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - Push

- (void)setupPush{
    
    self.gexinPusher = [GexinSdk createSdkWithAppId:kAppId
                                         appKey:kAppKey
                                      appSecret:kAppSecret
                                     appVersion:@"0.0.0"
                                       delegate:self
                                          error:nil];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
}

- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

- (void)showAPNS:(NSDictionary *)userInfo{
    ASLog(@"APNS:%@",userInfo);
    
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSDictionary class]]) {
        alert = [(NSDictionary *)alert objectForKey:@"body"];
    }
    
    NSString *payload = [userInfo objectForKey:@"payload"];
    if (payload && payload.length > 0) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString *link = [dict getStringValueForKey:@"link" defaultValue:@""];
        if (link.length > 0) {
            [UIAlertView showWithTitle:nil message:alert cancelButtonTitle:@"取消" otherButtonTitles:@[@"查看"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == [alertView cancelButtonIndex]) {
                    return ;
                }
                
                [Public jumpFromLink:link];
            }];
        }
        
    }else{
        [UIAlertView showWithTitle:nil message:alert cancelButtonTitle:@"取消" otherButtonTitles:nil tapBlock:nil];
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *dToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    ASLog(@"deviceToken:%@", dToken);
    
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:dToken];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self showAPNS:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self showAPNS:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    self.clientId = clientId;
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    ASLog(@"payload:%@",payloadMsg);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[payloadMsg dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *title = [dict getStringValueForKey:@"title" defaultValue:@""];
        NSString *body = [dict getStringValueForKey:@"body" defaultValue:@""];
        
        if (title.length == 0 || body.length == 0) {
            return;
        }
        
        NSInteger type = [dict getIntValueForKey:@"type" defaultValue:0];
        
        if (type == 2) {
            [UIAlertView showWithTitle:title message:body cancelButtonTitle:@"取消" otherButtonTitles:@[@"查看"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == [alertView cancelButtonIndex]) {
                    return ;
                }
                
                NSString *link = [dict getStringValueForKey:@"link" defaultValue:@""];
                [Public jumpFromLink:link];
            }];
        }else{
            [UIAlertView showWithTitle:title message:body cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
    }
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    ASLog(@"Push Error:%@",error.localizedDescription);
}

@end

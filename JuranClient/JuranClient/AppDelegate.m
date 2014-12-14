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
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate () <UINavigationControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [JRUser refreshToken:nil];
    
    [self setupShareSDK];
    [self setupTabbar];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (UITabBarItem *)setupTabbarItemTitle:(NSString *)title image:(NSString *)image selected:(NSString *)imageSel{
    UIImage *caseImage = [UIImage imageNamed:image];
    UIImage *caseImageSel = [UIImage imageNamed:imageSel];
    caseImage = [caseImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    caseImageSel = [caseImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UITabBarItem alloc] initWithTitle:title image:caseImage selectedImage:caseImageSel];
}

- (void)setupTabbar{
    CaseViewController *cs = [[CaseViewController alloc] init];
    UINavigationController *csNav = [Public navigationControllerFromRootViewController:cs];
    csNav.tabBarItem = [self setupTabbarItemTitle:@"案例" image:@"tabbar_case" selected:@"tabbar_case_hl"];
    
    DesignerViewController *des = [[DesignerViewController alloc] init];
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
    
    
    
//    self.tabBarController = [[LeveyTabBarController alloc] initWithViewControllers:@[homeNav,csNav,desNav,wikiNav,profileNav]
//                                                                        imageArray:@[@{@"Default": @"nav-home-default",
//                                                                                       @"Highlighted": @"nav-home-active",
//                                                                                       @"Seleted": @"nav-home-active"},
//  @{@"Default": @"nav-case-default",
//    @"Highlighted": @"nav-case-active",
//    @"Seleted": @"nav-case-active"},
//  @{@"Default": @"nav-designer-default",
//    @"Highlighted": @"nav-designer-active",
//    @"Seleted": @"nav-designer-active"},
//  @{@"Default": @"nav-wiki-default",
//    @"Highlighted": @"nav-wiki-active",
//    @"Seleted": @"nav-wiki-active"},
//  @{@"Default": @"nav-user-default",
//    @"Highlighted": @"nav-user-active",
//    @"Seleted": @"nav-user-active"}]];
//	_tabBarController.tabBar.backgroundColor = kTabBarBackgroundColor;
//	[_tabBarController setTabBarTransparent:YES];
    self.tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[csNav,topicNav,publishNav,desNav,profileNav];
    self.window.rootViewController = _tabBarController;
    
}

- (void)setupShareSDK{
    [ShareSDK registerApp:@"477b2576a9ca"];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"4218949951"
                               appSecret:@"444121dbfb4e449ba7caf573b617652c"
                             redirectUri:@"http://demo.juran.cn/member/sinalogin.htm"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"4218949951"
                                appSecret:@"444121dbfb4e449ba7caf573b617652c"
                              redirectUri:@"http://demo.juran.cn/member/sinalogin.htm"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801431266"
                                  appSecret:@"558f8c19eb566dcce87b898461b0cf24"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    [ShareSDK connect163WeiboWithAppKey:@"w2sMmVpSmY4zXCIX" appSecret:@"UGqxcqJQglAZkYd57nDGmJ5z8bh5TL9A" redirectUri:@"http://demo.juran.cn/member/sinalogin.htm"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQHLSDKAppKey
                           appSecret:QQHLSDKAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:QQHLSDKAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxbe9895c4d26b95dc"
                           wechatCls:[WXApi class]];
    
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

@end

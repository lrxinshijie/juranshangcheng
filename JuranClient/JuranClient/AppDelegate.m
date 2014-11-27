//
//  AppDelegate.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "HomeViewController.h"
#import "CaseViewController.h"
#import "DesignerViewController.h"
#import "WikiViewController.h"
#import "ProfileViewController.h"

@interface AppDelegate () <UINavigationControllerDelegate>

@property (nonatomic, strong) LeveyTabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupTabbar];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupTabbar{
    HomeViewController *home = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [Public navigationControllerFromRootViewController:home];
    
    CaseViewController *cs = [[CaseViewController alloc] init];
    UINavigationController *csNav = [Public navigationControllerFromRootViewController:cs];
    
    DesignerViewController *des = [[DesignerViewController alloc] init];
    UINavigationController *desNav = [Public navigationControllerFromRootViewController:des];
    
    WikiViewController *wiki = [[WikiViewController alloc] init];
    UINavigationController *wikiNav = [Public navigationControllerFromRootViewController:wiki];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    UINavigationController *profileNav = [Public navigationControllerFromRootViewController:profile];
    
    self.tabBarController = [[LeveyTabBarController alloc] initWithViewControllers:@[homeNav,csNav,desNav,wikiNav,profileNav]
                                                                        imageArray:@[@{@"Default": @"nav-home-default",
                                                                                       @"Highlighted": @"nav-home-active",
                                                                                       @"Seleted": @"nav-home-active"},
  @{@"Default": @"nav-case-default",
    @"Highlighted": @"nav-case-active",
    @"Seleted": @"nav-case-active"},
  @{@"Default": @"nav-designer-default",
    @"Highlighted": @"nav-designer-active",
    @"Seleted": @"nav-designer-active"},
  @{@"Default": @"nav-wiki-default",
    @"Highlighted": @"nav-wiki-active",
    @"Seleted": @"nav-wiki-active"},
  @{@"Default": @"nav-user-default",
    @"Highlighted": @"nav-user-active",
    @"Seleted": @"nav-user-active"}]];
	_tabBarController.tabBar.backgroundColor = kTabBarBackgroundColor;
	[_tabBarController setTabBarTransparent:YES];
    self.window.rootViewController = _tabBarController;
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController.hidesBottomBarWhenPushed){
        [_tabBarController hidesTabBar:YES animated:YES];
    }else{
        [_tabBarController hidesTabBar:NO animated:YES];
    }
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

@end

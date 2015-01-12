//
//  AppDelegate.h
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef kJuranDesigner
#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#ifdef kJuranDesigner
@property (nonatomic, strong) UITabBarController *tabBarController;
#else
@property (nonatomic, strong) UITabBarController *tabBarController;
#endif
@property (nonatomic, strong) NSString *clientId;
- (void)jumpToMain;

@end

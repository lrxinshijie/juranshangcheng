//
//  AppDelegate.h
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef kJuranDesigner
@class BMKMapManager;
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) NSString *clientId;
#ifndef kJuranDesigner
@property (strong, nonatomic) BMKMapManager* mapManager;
#endif
- (void)minusBadgeNumber:(NSInteger)num;
- (void)jumpToMain;

@end

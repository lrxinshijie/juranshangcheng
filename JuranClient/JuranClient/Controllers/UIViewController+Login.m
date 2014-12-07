//
//  UIViewController+Login.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "UIViewController+Login.h"
#import "LoginViewController.h"

@interface UIViewController ()

@end

@implementation UIViewController (Login)

- (BOOL)checkLogin:(VoidBlock)finished{
    if ([JRUser isLogin]) {
        return YES;
    }
    
    LoginViewController *login = [[LoginViewController alloc] init];
    login.block = finished;
    UINavigationController *loginNav = [Public navigationControllerFromRootViewController:login];
    [self presentViewController:loginNav animated:YES completion:^{
        
    }];
    
    return NO;
}

- (BOOL)checkLogin{
    return [self checkLogin:nil];
}

@end

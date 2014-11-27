//
//  UIViewController+Login.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "UIViewController+Login.h"
#import "LoginViewController.h"

@implementation UIViewController (Login)

- (BOOL)checkLogin{
    if ([JRUser isLogin]) {
        return YES;
    }
    
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [Public navigationControllerFromRootViewController:login];
    [self presentViewController:loginNav animated:YES completion:^{
        
    }];
    
    return NO;
}

- (void)nextAction{
    
}

@end

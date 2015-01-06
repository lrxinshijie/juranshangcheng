//
//  UIViewController+Login.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "UIViewController+Login.h"
#import "LoginViewController.h"
#import "MenuView.h"
#import "SearchViewController.h"

@interface UIViewController () <UIGestureRecognizerDelegate>

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

- (void)configureMenu{
    [self setLogBackBarButton:@"navbar_leftbtn_logo" target:self action:@selector(showMenu)];
#ifndef kJuranDesigner
    UISwipeGestureRecognizer *swipt = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    swipt.direction = UISwipeGestureRecognizerDirectionRight;
    swipt.delegate = self;
    [self.view addGestureRecognizer:swipt];
#endif
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return YES;
//}

- (void)configureSearch{
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
}

- (void)onSearch{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMenu{
    if ([[MenuView sharedView] superview]) {
        [self hideMenu];
    }else{
        [[MenuView sharedView] showMenu];
    }
}

- (void)hideMenu{
    [[MenuView sharedView] hideMenu];
}

- (void)setLogBackBarButton:(NSString *)imgStr target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width= -15;
    if ([UIImage imageNamed:imgStr].size.width>20.f) {
        btn.frame =CGRectMake(0,0, 120, 36);
    } else {
        btn.frame =CGRectMake(0,0, 20, 36);
        width = -18;
    }
    
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if (SystemVersionGreaterThanOrEqualTo7) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = width;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, buttonItem];
    }else{
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
}

@end

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
//    swipt.delegate = self;
    [self.view addGestureRecognizer:swipt];
#endif
}

- (void)configureCityTitle:(NSString *)title{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    UILabel *titleLabel = [titleView labelWithFrame:CGRectMake(0, 0, 40, 30) text:title textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    UIButton *cityButton = [titleView buttonWithFrame:CGRectMake(46, 0, 74, 30) target:self action:@selector(onCity:) title:@"北京市" backgroundImage:[UIImage imageNamed:@"bg-gray-down"]];
    cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cityButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleView addSubview:cityButton];
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
}

- (void)onCity:(UIButton *)btn{
    
}


- (void)configureScan{
    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"icon-scan"] leftBarButtonItemAction:@selector(onScan)];
}

- (void)configureSearchAndMore{
    UIButton *searchButton = [self.view buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(onSearch) image:[UIImage imageNamed:@"icon-search"]];
    UIButton *moreButton = [self.view buttonWithFrame:CGRectMake(35, 0, 35, 35) target:self action:@selector(onMore) image:[UIImage imageNamed:@"icon-dot"]];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [rightView addSubview:searchButton];
    [rightView addSubview:moreButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)onScan{
    
}

- (void)onMore{
    
}

- (void)configureSearch{
    [self configureRightBarButtonItemImage:[[ALTheme sharedTheme] imageNamed:@"icon-search"] rightBarButtonItemAction:@selector(onSearch)];
}

- (void)onSearch{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMenu{
#ifdef kJuranDesigner
    return;
#endif
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
//    [btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [btn setImage:[[ALTheme sharedTheme] imageNamed:@"navbar_leftbtn_logo"] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

#ifdef kJuranDesigner
    btn.adjustsImageWhenHighlighted = NO;
#endif
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

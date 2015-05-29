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
#import "UIViewController+Menu.h"
#import "QRBaseViewController.h"
#import "AppDelegate.h"

@interface UIViewController () <UIGestureRecognizerDelegate>

//@property (assign, nonatomic) BOOL couldClick;

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
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    UILabel *titleLabel = [titleView labelWithFrame:CGRectMake(0, 0, 40, 30) text:title textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
//    UIButton *cityButton = [titleView buttonWithFrame:CGRectMake(46, 0, 74, 30) target:self action:@selector(onCity:) title:[Public defaultCityName] backgroundImage:[UIImage imageNamed:@"bg-gray-down"]];
//    cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    cityButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [titleView addSubview:cityButton];
//    [titleView addSubview:titleLabel];
//    self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"北京站";
}

- (void)onCity:(UIButton *)btn{
    
}

- (void)configureGoBackPre{
    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"nav_backbtn"] leftBarButtonItemAction:@selector(onPreBack)];
}

- (void)configureScan{
    [self configureLeftBarButtonItemImage:[UIImage imageNamed:@"icon-scan"] leftBarButtonItemAction:@selector(onScan)];
}

- (void)configureMore{
     //[self configureRightBarButtonItemImage:[[ALTheme sharedTheme] imageNamed:@"icon-dot"] rightBarButtonItemAction:@selector(onMore)];
    UIButton *moreButton = [self.view buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(onMore) image:[UIImage imageNamed:@"icon-dot"]];
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -7);
    UILabel *countLabel = [self.view labelWithFrame:CGRectMake(28, 0, 18, 16)
                                               text:[NSString stringWithFormat:@"%d",[JRUser isLogin] && [JRUser currentUser].newPrivateLetterCount?[JRUser currentUser].newPrivateLetterCount:0]
                                          textColor:[UIColor whiteColor]
                                      textAlignment:NSTextAlignmentCenter
                                               font:[UIFont systemFontOfSize:12]];
    countLabel.backgroundColor = [UIColor redColor];
    countLabel.layer.cornerRadius = countLabel.bounds.size.height/2;
    countLabel.layer.masksToBounds = YES;
    countLabel.hidden = [JRUser isLogin] && [JRUser currentUser].newPrivateLetterCount>0 ? NO:YES;
    
    UILabel *readLabel = [self.view labelWithFrame:CGRectMake(30, 4, 8, 8)
                                               text:@""
                                          textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:1]];
    readLabel.backgroundColor = [UIColor redColor];
    readLabel.layer.cornerRadius = readLabel.bounds.size.height/2;
    readLabel.layer.masksToBounds = YES;
    if (countLabel.hidden) {
        readLabel.hidden = [JRUser isLogin] && [JRUser currentUser].newPushMsgCount>0 ? NO:YES;
    }else {
        readLabel.hidden = YES;
    }
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    rightView.clipsToBounds = NO;
    [rightView addSubview:moreButton];
    [rightView addSubview:countLabel];
    [rightView addSubview:readLabel];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)configureSearchAndMore{
    UIButton *searchButton = [self.view buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(onSearch) image:[UIImage imageNamed:@"icon-search"]];
    UIButton *moreButton = [self.view buttonWithFrame:CGRectMake(35, 0, 35, 35) target:self action:@selector(onMore) image:[UIImage imageNamed:@"icon-dot"]];
    UILabel *countLabel = [self.view labelWithFrame:CGRectMake(28+35, 0, 18, 16)
                                               text:[NSString stringWithFormat:@"%d",[JRUser isLogin] && [JRUser currentUser].newPrivateLetterCount?[JRUser currentUser].newPrivateLetterCount:0]
                                          textColor:[UIColor whiteColor]
                                      textAlignment:NSTextAlignmentCenter
                                               font:[UIFont systemFontOfSize:12]];
    countLabel.backgroundColor = [UIColor redColor];
    countLabel.layer.cornerRadius = countLabel.bounds.size.height/2;
    countLabel.layer.masksToBounds = YES;
    countLabel.hidden = [JRUser isLogin] && [JRUser currentUser].newPrivateLetterCount>0 ? NO:YES;
    
    UILabel *readLabel = [self.view labelWithFrame:CGRectMake(30+35, 4, 8, 8)
                                              text:@""
                                         textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:1]];
    readLabel.backgroundColor = [UIColor redColor];
    readLabel.layer.cornerRadius = readLabel.bounds.size.height/2;
    readLabel.layer.masksToBounds = YES;
    if (countLabel.hidden) {
        readLabel.hidden = [JRUser isLogin] && [JRUser currentUser].newPushMsgCount>0 ? NO:YES;
    }else {
        readLabel.hidden = YES;
    }
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    rightView.clipsToBounds = NO;
    [rightView addSubview:searchButton];
    [rightView addSubview:moreButton];
    [rightView addSubview:countLabel];
    [rightView addSubview:readLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)onPreBack {
    int count = self.navigationController.viewControllers.count;
    if (count>2) {
        if ([self.navigationController.viewControllers[count - 2] isKindOfClass:[SearchViewController class]])
            [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
        else
            [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onScan{
    if (![QRBaseViewController isRuning]) {
        QRBaseViewController * vc = [[QRBaseViewController alloc] initWithNibName:@"QRBaseViewController" bundle:nil isPopNavHide:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onMore{
    [self showAppMenu:nil];
}

- (void)onMoreWithoutHomeAndShare{
    [self showAppMenuWithoutHomeAndShare];
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

- (void)reloadMoreMenu {
    if (self.navigationController.viewControllers.count>2) {
        [self configureMore];
    }else {
        [self configureSearchAndMore];
    }
}

+ (void)loadCenterInfo{
    if (![JRUser isLogin]) {
        return;
    }
#ifndef kJuranDesigner
    NSString *url = JR_MYCENTERINFO;
#else
    NSString *url = JR_GET_DESIGNER_CENTERINFO;
#endif
    [[ALEngine shareEngine] pathURL:url parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes",kNetworkParamKeyShowErrorDefaultMessage:@"No"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [[JRUser currentUser] buildUpProfileDataWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMsgCenterReloadData object:nil];
                    [ApplicationDelegate setBadgeNumber:[[JRUser currentUser] newPrivateLetterCount]];
                });
            }
        }
    }];
}
@end

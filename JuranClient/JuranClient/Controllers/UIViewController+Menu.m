//
//  UIViewController+Menu.m
//  JuranClient
//
//  Created by 彭川 on 15/5/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "UIViewController+Menu.h"
#import "KxMenu.h"
#import "AppDelegate.h"
#import "PushMessageViewController.h"
#import "PrivateMessageViewController.h"

@interface UIViewController ()

@end

@implementation UIViewController (Menu)

- (void)showAppMenuIsShare:(BOOL)isFlag
{
    if (![JRUser isLogin]) {
        [self createAppMenuIsShare:isFlag isRead:YES numOfMsg:0];
    }else {
        [self showHUD];
        NSString *url = JR_MYCENTERINFO;
        [[ALEngine shareEngine] pathURL:url parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
            [self hideHUD];
            if (!error) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    BOOL isRead = ![data getBoolValueForKey:@"newPushMsgCount" defaultValue:NO];
                    NSInteger num = [data getIntValueForKey:@"newPrivateLetterCount" defaultValue:0];
                    [self createAppMenuIsShare:isFlag isRead:isRead numOfMsg:num];
                }
            }
        }];
    }
    
}

- (void)createAppMenuIsShare:(BOOL)isFlag isRead:(BOOL)isRead numOfMsg:(NSInteger)num {
    [KxMenu dismissMenu];
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    if (isFlag) {
        [menuItems addObject:[KxMenuItem menuItem:@"分享"
                                            image:[UIImage imageNamed:@"menu-icon-share"]
                                           target:self
                                           action:@selector(onShare:)]];
    }
    
    NSArray *menus =
    @[[KxMenuItem menuItem:@"通知"
                     image:[UIImage imageNamed:@"menu-icon-notice"]
                    isRead:isRead
               numOfUnread:0
                    target:self
                    action:@selector(onNotice:)],
      
      [KxMenuItem menuItem:@"私信"
                     image:[UIImage imageNamed:@"menu-icon-msg"]
                    isRead:YES
               numOfUnread:num
                    target:self
                    action:@selector(onMsg:)],
      
      [KxMenuItem menuItem:@"平台客服"
                     image:[UIImage imageNamed:@"menu-icon-svr"]
                    target:self
                    action:@selector(onCustomService:)],
      
      [KxMenuItem menuItem:@"首页"
                     image:[UIImage imageNamed:@"menu-icon-home"]
                    target:self
                    action:@selector(onHome:)],
      ];
    [menuItems addObjectsFromArray:menus];
    
    [self.navigationController.view setClipsToBounds:NO];
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(kWindowWidth-35, 52, 0, 0)
                 menuItems:menuItems];
}

- (void) onShare:(id)sender
{
    NSLog(@"%@", sender);
}

- (void) onNotice:(id)sender
{
    PushMessageViewController *vc = [[PushMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [[ApplicationDelegate tabBarController].viewControllers[4] pushViewController:vc animated:YES];
    [ApplicationDelegate.tabBarController setSelectedIndex:4];
}

- (void) onMsg:(id)sender
{
    PrivateMessageViewController *vc = [[PrivateMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [[ApplicationDelegate tabBarController].viewControllers[4] pushViewController:vc animated:YES];
    [ApplicationDelegate.tabBarController setSelectedIndex:4];
}

- (void) onCustomService:(id)sender
{
    [self loadCustomService];
}

- (void) onHome:(id)sender
{
    [ApplicationDelegate.tabBarController setSelectedIndex:0];
    [[ApplicationDelegate tabBarController].viewControllers[0] popToRootViewControllerAnimated:YES];
}

//JR_CUSTOMER_SERVICE
- (void)loadCustomService{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_CUSTOMER_SERVICE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            NSString *tel = [data getStringValueForKey:@"telphone" defaultValue:@""];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
}

@end

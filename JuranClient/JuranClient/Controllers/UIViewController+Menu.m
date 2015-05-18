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
//#import "UIViewController+Login.h"

@interface UIViewController ()

@end

@implementation UIViewController (Menu)

- (void)showAppMenu:(VoidBlock)shareBlock
{
    [self createAppMenuWithShareBlock:shareBlock isRead:[JRUser isLogin] && [JRUser currentUser].newPushMsgCount>0?NO:YES
                             numOfMsg:[JRUser isLogin] && [JRUser currentUser].newPrivateLetterCount?[JRUser currentUser].newPrivateLetterCount:0];
    
    
    
    
    
    
//    if (![JRUser isLogin]) {
//        [self createAppMenuWithShareBlock:shareBlock isRead:YES numOfMsg:0];
//    }else {
//        [self showHUD];
//        [[ALEngine shareEngine] pathURL:JR_MYCENTERINFO parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
//            [self hideHUD];
//            if (!error) {
//                if ([data isKindOfClass:[NSDictionary class]]) {
//                    BOOL isRead = ![data getBoolValueForKey:@"newPushMsgCount" defaultValue:NO];
//                    NSInteger num = [data getIntValueForKey:@"newPrivateLetterCount" defaultValue:0];
//                    [self createAppMenuWithShareBlock:shareBlock isRead:isRead numOfMsg:num];
//                }
//            }else{
//                [self createAppMenuWithShareBlock:shareBlock isRead:YES numOfMsg:0];
//            }
//        }];
//    }
    
}

- (void)dismissAppMenu {
    [KxMenu dismissMenu];
}

- (void)createAppMenuWithShareBlock:(VoidBlock)shareBlock
                             isRead:(BOOL)isRead
                           numOfMsg:(NSInteger)num {
    [KxMenu dismissMenu];
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    if (shareBlock) {
        [menuItems addObject:[KxMenuItem menuItem:@"分享"
                                            image:[UIImage imageNamed:@"menu-icon-share"]
                                           isRead:YES
                                      numOfUnread:0
                                           target:self
                                           action:@selector(onShare:)
                                            block:shareBlock]];
    }
    
    [menuItems addObject:[KxMenuItem menuItem:@"通知"
                                        image:[UIImage imageNamed:@"menu-icon-notice"]
                                       isRead:isRead
                                  numOfUnread:0
                                       target:self
                                       action:@selector(onNotice:)
                                        block:nil]];
    
    [menuItems addObject:[KxMenuItem menuItem:@"私信"
                                        image:[UIImage imageNamed:@"menu-icon-msg"]
                                       isRead:YES
                                  numOfUnread:num
                                       target:self
                                       action:@selector(onMsg:)
                                        block:nil]];
    
    [menuItems addObject:[KxMenuItem menuItem:@"平台客服"
                                        image:[UIImage imageNamed:@"menu-icon-svr"]
                                       target:self
                                       action:@selector(onCustomService:)]];
    
    if (![[NSString stringWithUTF8String:object_getClassName(self)]  isEqual: @"RootViewController"]) {
        [menuItems addObject:[KxMenuItem menuItem:@"首页"
                                            image:[UIImage imageNamed:@"menu-icon-home"]
                                           target:self
                                           action:@selector(onHome:)]];
    }
    
    [self.navigationController.view setClipsToBounds:NO];
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(kWindowWidth-35, 52, 0, 0)
                 menuItems:menuItems];
    
}

- (void) onShare:(id)sender
{
    KxMenuItem *shareItem = (KxMenuItem *)sender;
    if (shareItem.block) {
        shareItem.block();
    }
}

- (void) onNotice:(id)sender
{
    if (![self checkLogin]) {
        return;
    }
    PushMessageViewController *vc = [[PushMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
//    [[ApplicationDelegate tabBarController].viewControllers[4] pushViewController:vc animated:YES];
//    [ApplicationDelegate.tabBarController setSelectedIndex:4];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onMsg:(id)sender
{
    if (![self checkLogin]) {
        return;
    }
    PrivateMessageViewController *vc = [[PrivateMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
//    [[ApplicationDelegate tabBarController].viewControllers[4] pushViewController:vc animated:YES];
//    [ApplicationDelegate.tabBarController setSelectedIndex:4];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onCustomService:(id)sender
{
    [self loadCustomService];
}

- (void) onHome:(id)sender
{
    [[ApplicationDelegate tabBarController].viewControllers[0] setNavigationBarHidden:NO];
    [[ApplicationDelegate tabBarController].viewControllers[0] popToRootViewControllerAnimated:NO];
    [ApplicationDelegate.tabBarController setSelectedIndex:0];
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

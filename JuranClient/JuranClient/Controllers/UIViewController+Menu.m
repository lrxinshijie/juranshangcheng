//
//  UIViewController+Menu.m
//  JuranClient
//
//  Created by 彭川 on 15/5/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "UIViewController+Menu.h"
#import "KxMenu.h"

@interface UIViewController ()

@end

@implementation UIViewController (Menu)

- (void)showAppMenuIsShare:(BOOL)isFlag
{
    [KxMenu dismissMenu];
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    if (isFlag) {
        [menuItems addObject:[KxMenuItem menuItem:@"分享"
                                            image:[UIImage imageNamed:@"menu-icon-share"]
                                           target:self
                                           action:@selector(pushMenuItem:)]];
    }
    
    NSArray *menus =
    @[[KxMenuItem menuItem:@"通知"
                     image:[UIImage imageNamed:@"menu-icon-notice"]
                    isRead:NO
               numOfUnread:0
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"私信"
                     image:[UIImage imageNamed:@"menu-icon-msg"]
                    isRead:YES
               numOfUnread:99
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"平台客服"
                     image:[UIImage imageNamed:@"menu-icon-svr"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"首页"
                     image:[UIImage imageNamed:@"menu-icon-home"]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    [menuItems addObjectsFromArray:menus];
    
    [self.navigationController.view setClipsToBounds:NO];
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(kWindowWidth-35, 52, 0, 0)
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}

@end

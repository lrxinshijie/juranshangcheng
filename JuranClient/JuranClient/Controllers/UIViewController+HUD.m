//
//  UIViewController+HUD.m
//  BabyCamera
//
//  Created by Kowloon on 14-8-7.
//  Copyright (c) 2014年 Kowloon. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "GlobalPopupAlert.h"
#import "MBProgressHUD.h"

@implementation UIViewController (HUD)

- (void)showHUD{
    [self showHUDFromTitle:@"Loading..."];
}

- (void)showTip:(NSString *)tip{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [GlobalPopupAlert show:tip andFadeOutAfter:1.5];
    });
}

- (void)setHUDTitle:(NSString *)title{
    [MBProgressHUD HUDForView:self.view].labelText = title;
}

- (void)showHUDFromTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if ([[MBProgressHUD allHUDsForView:self.view] count] == 0) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        
        [self setHUDTitle:title];
    });
}

- (void)hideHUD{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}

@end

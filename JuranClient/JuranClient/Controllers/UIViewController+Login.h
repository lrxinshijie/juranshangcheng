//
//  UIViewController+Login.h
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Login)

- (BOOL)checkLogin:(VoidBlock)finished;
- (BOOL)checkLogin;


- (void)configureCityTitle:(NSString *)title;
- (void)configureMenu;
- (void)configureSearch;
- (void)configureScan;
- (void)configureMore;
- (void)configureSearchAndMore;
- (void)configureGoBackPre;
- (void)showMenu;
- (void)onSearch;
@end

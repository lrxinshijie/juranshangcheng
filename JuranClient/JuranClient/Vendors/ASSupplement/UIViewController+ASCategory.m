//
//  UIViewController+ASCategory.m
//  Path
//
//  Created by Kowloon on 12-7-30.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "UIViewController+ASCategory.h"
#import "UIView+ASCategory.h"
#import "NSObject+ASCategory.h"
#import "ALEngine.h"

@implementation UIViewController (ASCategory)

#pragma mark - Compatible

- (void)presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion animated: (BOOL)flag
{
//    if (SystemVersionGreaterThanOrEqualTo5) {
//        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
//    } else if(SystemVersionGreaterThanOrEqualTo6){
//        [self presentModalViewController:viewControllerToPresent animated:flag];
//    }else{
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
//    }
}

- (void)dismissViewControllerCompletion: (void (^)(void))completion animated: (BOOL)flag
{
//    if (SystemVersionGreaterThanOrEqualTo5) {
        [self dismissViewControllerAnimated:flag completion:completion];
//    } else {
//        [self dismissModalViewControllerAnimated:flag];
//    }
}

- (void)configureLeftBarButtonUniformly
{
    [self configureStatusBar];
    if (self.navigationController.viewControllers.count > 1) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:@selector(back:) image:[UIImage imageNamed:@"nav_backbtn"]]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:@selector(back:) image:[[ALTheme sharedTheme] imageNamed:@"nav_backbtn"]]];
    }
}

- (void)configureBackground{
    [self configureStatusBar];
    UIImage *image = [UIImage imageNamed:@"home_bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)configureLeftBarButtonItemImage:(UIImage *)image leftBarButtonItemAction:(SEL)action
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:action image:image]];
}

- (void)configureRightBarButtonItemImage:(UIImage *)image rightBarButtonItemAction:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:action image:image]];
}

- (void)back:(id)sender
{
    [ALEngine cancelOperationsWithClass:self];
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (CGRect)mainBounds
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight);
}

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - minus);
}

- (void)configureStatusBar{
    if (SystemVersionGreaterThanOrEqualTo7) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end

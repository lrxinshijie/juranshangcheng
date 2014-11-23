//
//  UIViewController+ASCategory.h
//  Path
//
//  Created by Kowloon on 12-7-30.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ASCategory) 

- (void)presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion animated: (BOOL)flag;
- (void)dismissViewControllerCompletion: (void (^)(void))completion animated: (BOOL)flag;
- (void)configureLeftBarButtonUniformly;
- (void)configureLeftBarButtonItemImage:(UIImage *)image leftBarButtonItemAction:(SEL)action;
- (void)configureRightBarButtonItemImage:(UIImage *)image rightBarButtonItemAction:(SEL)action;
- (void)back:(id)sender;    /* [self.navigationController popViewControllerAnimated:YES] is the default action, overwrite it if needed */
- (CGRect)mainBounds;
- (CGRect)mainBoundsMinusHeight:(CGFloat)minus;

- (void)configureBackground;

- (void)configureStatusBar;

@end

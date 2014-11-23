//
//  UINavigationBar+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-9-3.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UINavigationBar+ASCategory.h"
#import "UIView+ASCategory.h"
#import "NSObject+ASCategory.h"
#import "UIImage+ASCategory.h"

@implementation UINavigationBar (ASCategory)

- (void)setBackgroundImageWithColor:(UIColor *)color
{
    if (SystemVersionGreaterThanOrEqualTo5) {
        [self setBackgroundImage:[UIImage imageFromColor:color] forBarMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIImage imageFromColor:color] forBarMetrics:UIBarMetricsLandscapePhone];
    } else {
        [self setTintColor:color];
    }
}

@end

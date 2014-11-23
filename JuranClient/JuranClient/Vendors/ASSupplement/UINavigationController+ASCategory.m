//
//  UINavigationController+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-9-3.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UINavigationController+ASCategory.h"

@implementation UINavigationController (ASCategory)

- (UIViewController *)rootViewController
{
    if (self.viewControllers) {
        return [self.viewControllers objectAtIndex:0];
    } else {
        return nil;
    }
}

@end

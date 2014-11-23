//
//  UIAlertView+ASCategory.m
//  ASSupplement
//
//  Created by Kowloon on 12-5-15.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UIAlertView+ASCategory.h"

@implementation UIAlertView (ASCategory)

- (void)showElegantly 
{
    BOOL avoid = NO;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSInteger count = [windows count];
    for (NSInteger n = 0; n < count; n ++) {
        UIWindow *window = [windows objectAtIndex:n];
        if ([window isKindOfClass:NSClassFromString(@"_UIAlertNormalizingOverlayWindow")]) {
            UIAlertView *alertView = [[window subviews] objectAtIndex:0];
            if (alertView.visible) {
                avoid = YES;
                break;
            }
        }
    }
    if (!avoid) {
        [self show];
    }
}

@end

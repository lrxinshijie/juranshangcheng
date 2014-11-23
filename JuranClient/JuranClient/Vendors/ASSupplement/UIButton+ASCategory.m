//
//  UIButton+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-10-18.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+ASCategory.h"

static char UIButtonMaskLabel;

@implementation UIButton (ASCategory)

@dynamic maskLabel;

- (void)setMaskLabel:(UILabel *)maskLabel
{
    [self willChangeValueForKey:@"maskLabel"];
    objc_setAssociatedObject(self, &UIButtonMaskLabel, maskLabel, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"maskLabel"];
}

- (UILabel *)maskLabel
{
    UILabel *label = objc_getAssociatedObject(self, &UIButtonMaskLabel);
    if(!label) {
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        label.textColor = [UIColor whiteColor];
        self.maskLabel = label;
        [self addSubview:label];
    }
    return label;
}

@end

//
//  UITextField+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-8-7.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UITextField+ASCategory.h"
#import "UIView+ASCategory.h"

@implementation UITextField (ASCategory)

- (UIView *)roundedRectBackgroundView
{
    if ([self.subviews count] > 0) {
        return [self.subviews objectAtIndex:0];
    } else {
        return nil;
    }
}

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius paddingWidth:(CGFloat)paddingWidth
{
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = UITextBorderStyleNone;
    [self configureWithBorderColor:borderColor borderWidth:borderWidth cornerRadius:cornerRadius];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingWidth, self.bounds.size.height)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = paddingView;
}

- (void)configurePlaceholderColor:(UIColor *)color{
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

@end

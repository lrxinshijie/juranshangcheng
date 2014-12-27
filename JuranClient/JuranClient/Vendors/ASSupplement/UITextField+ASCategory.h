//
//  UITextField+ASCategory.h
//  PhoneOnline
//
//  Created by Kowloon on 12-8-7.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ASCategory)

- (UIView *)roundedRectBackgroundView;
- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius paddingWidth:(CGFloat)paddingWidth;
- (void)configurePlaceholderColor:(UIColor *)color;
@end

//
//  UIImage+ASCategory.m
//  Supplement
//
//  Created by Kowloon on 12-2-7.
//  Copyright (c) 2011年 Goome. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+ASCategory.h"
#import "ASPlaceholderTextView.h"
#import "UIImage+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation UIView (ASCategory)

- (UIViewController *)viewController
{
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

- (UIImageView *)imageViewFromView:(UIView *)view
{
    return [[UIImageView alloc] initWithImage:[UIImage imageFromView:view]];
}

- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    button.showsTouchWhenHighlighted = YES;
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat top = (frame.size.height - height) * .5;
    CGFloat left = 0;
    CGFloat bottom = top;
    CGFloat right = frame.size.width - width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation
{
    return [self buttonWithFrame:frame target:target action:action title:title image:image imageIndentation:indentation navigated:NO];
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation
                    navigated:(BOOL)navigated
{
    CGFloat navigationButtonMargin = 6;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor purpleColor];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
//    [[button titleLabel] setBackgroundColor:[UIColor orangeColor]];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat top = (frame.size.height - height) * .5;
    CGFloat left = indentation;
    CGFloat bottom = top;
    CGFloat right = frame.size.width - left - width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    BOOL putTitleLeft = left > frame.size.width * .5 ? YES : NO;
    if (navigated) {
        CGFloat titleLeft = putTitleLeft ? frame.size.width - left - navigationButtonMargin : left + navigationButtonMargin;
        CGFloat titleRight = putTitleLeft ? frame.size.width - left : left;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, titleLeft, 0, titleRight)];
    } else {
        CGFloat titleIndentation = putTitleLeft ? frame.size.width - left : left;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, titleIndentation, 0, putTitleLeft ? titleIndentation + width : titleIndentation - width)];
    }
    
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        title:(NSString *)title
              backgroundImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

- (UILabel *)labelWithFrame:(CGRect)frame 
                       text:(NSString *)text 
                  textColor:(UIColor *)color 
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)style
                    backgroundColor:(UIColor *)backgroundColor
                               text:(NSString *)text 
                          textColor:(UIColor *)textColor 
                      textAlignment:(NSTextAlignment)alignment
                               font:(UIFont *)font;
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = style;
    textField.backgroundColor = backgroundColor;
    textField.text = text;
    textField.textColor = textColor;
    textField.textAlignment = (NSTextAlignment)alignment;
    textField.font = font;
    return textField;
}

- (UITextView *)textViewWithFrame:(CGRect)frame 
                  backgroundColor:(UIColor *)backgroundColor
                             text:(NSString *)text 
                        textColor:(UIColor *)textColor 
                    textAlignment:(NSTextAlignment)alignment
                             font:(UIFont *)font;
{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.backgroundColor = backgroundColor;
    textView.text = text;
    textView.textColor = textColor;
    textView.textAlignment = (NSTextAlignment)alignment;
    textView.font = font;
    return textView;
}

- (ASPlaceholderTextView *)textViewWithFrame:(CGRect)frame 
                             backgroundColor:(UIColor *)backgroundColor
                                        text:(NSString *)text 
                                   textColor:(UIColor *)textColor 
                               textAlignment:(NSTextAlignment)alignment
                                        font:(UIFont *)font 
                                  placehoder:(NSString *)placeholder 
                            placeholderColor:(UIColor *)placeholderColor 
{
    ASPlaceholderTextView *textView = [[ASPlaceholderTextView alloc] initWithFrame:frame];
    textView.text = text;
    textView.textColor = textColor;
    textView.textAlignment = (NSTextAlignment)alignment;
    textView.font = font;
    textView.backgroundColor = backgroundColor;
    textView.placeholder = placeholder;
    textView.placeholderColor = placeholderColor;
    return textView;
}

- (UISearchBar *)searchBarWithFrame:(CGRect)frame 
                 clearBarBackground:(BOOL)clearBar 
                    clearButtonMode:(UITextFieldViewMode)mode
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    for (UIView *view in searchBar.subviews) {
        if (clearBar && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.clearButtonMode = mode;
        }
    }
    return searchBar;
}

- (UISearchBar *)searchBarRoundedRectWithFrame:(CGRect)frame 
                            clearBarBackground:(BOOL)clearBar 
                               clearButtonMode:(UITextFieldViewMode)mode 
                      clearTextFieldBackground:(BOOL)clearTextField
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    for (UIView *view in searchBar.subviews) {
        if (clearBar && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.clearButtonMode = mode;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            if (clearTextField) {
                [[textField.subviews lastObject] removeFromSuperview];
            }
        }
    }
    return searchBar;
}

- (UITableView *)tableViewWithFrame:(CGRect)frame 
                              style:(UITableViewStyle)style 
                     backgroundView:(UIView *)backgroundView 
                         dataSource:(id<UITableViewDataSource>)dataSource 
                           delegate:(id<UITableViewDelegate>)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.backgroundView = backgroundView;
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    tableView.backgroundColor = [UIColor whiteColor];
    
    if (SystemVersionGreaterThanOrEqualTo7) {
        tableView.separatorInset = UIEdgeInsetsZero;
    }
    tableView.tableFooterView = [[UIView alloc] init];
    
    return tableView;
}


- (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items 
                            segmentedControlStyle:(UISegmentedControlStyle)style 
                                        momentary:(BOOL)momentary
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.segmentedControlStyle = style;
    segmentedControl.momentary = momentary;
    return segmentedControl;
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action
{
    return [self addTapGestureRecognizerWithTarget:target action:action numberOfTapsRequired:1 delegate:nil];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action delegate:(id <UIGestureRecognizerDelegate>)delegate
{
    return [self addTapGestureRecognizerWithTarget:target action:action numberOfTapsRequired:1 delegate:delegate];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired
{
    return [self addTapGestureRecognizerWithTarget:target action:action numberOfTapsRequired:numberOfTapsRequired delegate:nil];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired delegate:(id <UIGestureRecognizerDelegate>)delegate
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequired;
    tapGestureRecognizer.delegate = delegate;
    [self addGestureRecognizer:tapGestureRecognizer];
    return tapGestureRecognizer;
}

- (void)configureFrameAppendingHeight:(CGFloat)appending
{
    CGRect rect = self.frame;
    rect.size.height += appending;
    self.frame = rect;
}

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
}

@end

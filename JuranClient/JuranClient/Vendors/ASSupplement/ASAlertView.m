//
//  ASAlertView.m
//  ASSupplement
//
//  Created by Kowloon on 12-5-9.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "ASAlertView.h"

@interface ASAlertView ()

- (void)traverseForTheUsefulItems;
- (void)configureDefaultValue;
- (void)configureBackgroundImageView;
- (void)configureTitleLabel;
- (void)configureSubtitleLabel;
- (void)configureButtons;
- (void)configureTextView;

@end

@implementation ASAlertView

@synthesize backgroundImage = __backgroundImage;

@synthesize titleFont = __titleFont;
@synthesize titleTextColor = __titleTextColor;
@synthesize titleTextAlignment = __titleTextAlignment;
@synthesize titleMarginHorizontalBounds = __titleMarginHorizontalBounds;
@synthesize titleMarginTopBounds = __titleMarginTopBounds;

@synthesize subtitleFont = __subtitleFont;
@synthesize subtitleTextColor = __subtitleTextColor;
@synthesize subtitleTextAlignment = __subtitleTextAlignment;
@synthesize subtitleMarginHorizontalBounds = __subtitleMarginHorizontalBounds;
@synthesize subtitleMarginTopBounds = __subtitleMarginTopBounds;

@synthesize buttonMarginHorizontalBounds = __buttonMarginHorizontalBounds;
@synthesize buttonMarginBottomBounds = __buttonMarginBottomBounds;
@synthesize buttonTextColor = __buttonTextColor;
@synthesize buttonBackgroundImageStateNormal = __buttonBackgroundImageStateNormal;
@synthesize buttonBackgroundImageStateHighlighted = __buttonBackgroundImageStateHighlighted;

@synthesize textViewMarginTopBounds = __textViewMarginTopBounds;
@synthesize textViewMarginHorizontalBounds = __textViewMarginHorizontalBounds;
@synthesize textViewFont = __textViewFont;
@synthesize textViewTextColor = __textViewTextColor;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        [self configureDefaultValue];
    }
    return self;
}

- (void)dealloc{
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    [self traverseForTheUsefulItems];
    
    //NSLog(@"drawRect:\n%@",self.subviews);
    
    
    [self configureBackgroundImageView];
    [self configureTitleLabel];
    [self configureSubtitleLabel];
    [self configureButtons];
    [self configureTextView];
}

#pragma mark - Private

- (void)traverseForTheUsefulItems 
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            if (!__backgroundImageView) {
                __backgroundImageView = (UIImageView *)subview;
            } else {
                [subview removeFromSuperview];    //remove the extra background image coming along with the textView
            }
        } else if ([subview isKindOfClass:[UILabel class]]) {
            if (!__titleLabel) {
                __titleLabel = (UILabel *)subview;
            } else if (!__subtitleLabel) {
                __subtitleLabel = (UILabel *)subview;
            }
        } else if ([subview isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            if (!__buttons) {
                __buttons = [[NSMutableArray alloc] init];
            }
            [__buttons addObject:subview];
        } else if ([subview isKindOfClass:NSClassFromString(@"UIAlertTextView")]) {
            __textView = (UITextView *)subview;
        }
    }
}

- (void)configureDefaultValue 
{
    self.backgroundImage = nil;
    
    self.titleFont = [UIFont fontWithName:@"Helvetica" size:[UIFont buttonFontSize]];
    self.titleTextColor = [UIColor whiteColor];
    self.titleTextAlignment = NSTextAlignmentCenter;
    self.titleMarginHorizontalBounds = 0;
    self.titleMarginTopBounds = 0;
    
    self.subtitleFont = [UIFont fontWithName:@"Helvetica" size:[UIFont labelFontSize] - 1];
    self.subtitleTextColor = [UIColor whiteColor];
    self.subtitleTextAlignment = NSTextAlignmentCenter;
    self.subtitleMarginHorizontalBounds = 0;
    self.subtitleMarginTopBounds = 0;
    
    self.buttonMarginHorizontalBounds = 0;
    self.buttonMarginBottomBounds = 0;
    self.buttonTextColor = [UIColor whiteColor];
    self.buttonBackgroundImageStateNormal = nil;
    self.buttonBackgroundImageStateHighlighted = nil;
    
    self.textViewMarginHorizontalBounds = 0;
    self.textViewMarginTopBounds = 0;
    self.textViewFont = [UIFont fontWithName:@"Helvetica" size:[UIFont labelFontSize] - 1];
    self.textViewTextColor = [UIColor blackColor];
}

- (void)configureBackgroundImageView 
{
    if (self.backgroundImage) {
        __backgroundImageView.image = __backgroundImage;
    }
}

- (void)configureTitleLabel 
{
    __titleLabel.font = __titleFont;
    __titleLabel.textColor = __titleTextColor;
    __titleLabel.textAlignment = (NSTextAlignment)__titleTextAlignment;
    __titleLabel.shadowColor = [UIColor clearColor];
    __titleLabel.shadowOffset = CGSizeZero;
    CGRect frame = __titleLabel.frame;
    if ( __titleLabel.textAlignment == NSTextAlignmentLeft) {
        frame.origin.x += __titleMarginHorizontalBounds;
    } else if ( __titleLabel.textAlignment == NSTextAlignmentRight) {
        frame.origin.x -= __titleMarginHorizontalBounds;
    }
    frame.origin.y += __titleMarginTopBounds;
    __titleLabel.frame = frame;
}

- (void)configureSubtitleLabel 
{
    __subtitleLabel.font = __subtitleFont;
    __subtitleLabel.textColor = __subtitleTextColor;
    __subtitleLabel.textAlignment = (NSTextAlignment)__subtitleTextAlignment;
    __subtitleLabel.shadowColor = [UIColor clearColor];
    __subtitleLabel.shadowOffset = CGSizeZero;
    CGRect frame = __subtitleLabel.frame;
    if (__subtitleLabel.textAlignment == NSTextAlignmentLeft) {
        frame.origin.x += __subtitleMarginHorizontalBounds;
    } else if (__subtitleLabel.textAlignment == NSTextAlignmentRight) {
        frame.origin.x -= __subtitleMarginHorizontalBounds;
    }
    frame.origin.y += __subtitleMarginTopBounds;
    __subtitleLabel.frame = frame;
}

- (void)configureButtons 
{
    for (UIButton *button in __buttons) {
        button.titleLabel.textColor = __buttonTextColor;
        [button setTitleColor:__buttonTextColor forState:UIControlStateNormal];
        [button setTitleColor:__buttonTextColor forState:UIControlStateHighlighted];
        button.titleLabel.shadowColor = [UIColor clearColor];
        button.titleLabel.shadowOffset = CGSizeZero;
        if (self.buttonBackgroundImageStateNormal) {
            [button setBackgroundImage:__buttonBackgroundImageStateNormal forState:UIControlStateNormal];
        }
        if (self.buttonBackgroundImageStateHighlighted) {
            [button setBackgroundImage:__buttonBackgroundImageStateHighlighted forState:UIControlStateHighlighted];
        }
        CGRect frame = button.frame;
        frame.origin.x += __buttonMarginHorizontalBounds;
        frame.origin.y -= __buttonMarginBottomBounds;
        frame.size.width -= 2 * __buttonMarginHorizontalBounds;
        button.frame = frame;
    }
}

- (void)configureTextView 
{
    __textView.font = __textViewFont;
    __textView.textColor = __textViewTextColor;
    CGRect frame = __textView.frame;
    frame.origin.x += __textViewMarginHorizontalBounds;
    frame.origin.y += __textViewMarginTopBounds;
    frame.size.width -= 2 * __textViewMarginHorizontalBounds;
    frame.size.height -= __textViewMarginTopBounds + __buttonMarginBottomBounds;
    __textView.frame = frame;
}

@end

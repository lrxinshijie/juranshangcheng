//
//  ASAlertView.h
//  ASSupplement
//
//  Created by Kowloon on 12-5-9.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAlertView : UIAlertView {
@private
    UIImageView     *__backgroundImageView;
    UILabel         *__titleLabel;
    UILabel         *__subtitleLabel;
    UITextView      *__textView;
    NSMutableArray  *__buttons;
    
    //properties below allow to be configured
    
    UIImage         *__backgroundImage;
    
    UIFont          *__titleFont;
    UIColor         *__titleTextColor;
    UITextAlignment __titleTextAlignment;
    NSUInteger      __titleMarginHorizontalBounds;
    NSUInteger      __titleMarginTopBounds;
    
    UIFont          *__subtitleFont;
    UIColor         *__subtitleTextColor;
    UITextAlignment __subtitleTextAlignment;
    NSUInteger      __subtitleMarginHorizontalBounds;
    NSUInteger      __subtitleMarginTopBounds;
    
    NSUInteger      __buttonMarginHorizontalBounds;
    NSUInteger      __buttonMarginBottomBounds;
    UIColor         *__buttonTextColor;
    UIImage         *__buttonBackgroundImageStateNormal;
    UIImage         *__buttonBackgroundImageStateHighlighted;
    
    //properties below are useful only when subtilte's length is quite huge
    
    NSUInteger      __textViewMarginHorizontalBounds;
    NSUInteger      __textViewMarginTopBounds;
    UIFont          *__textViewFont;
    UIColor         *__textViewTextColor;
}

/* default is nil, and use the system's blue background image */
@property (strong, nonatomic) UIImage *backgroundImage;

/* default is Helvetica, 18 px */
@property (strong, nonatomic) UIFont *titleFont;

/* default is whiteColor */
@property (strong, nonatomic) UIColor *titleTextColor;

/* default is UITextAlignmentCenter */
@property (assign, nonatomic) UITextAlignment titleTextAlignment;

/* use this value to change the distance between the title and horizontal bounds, default is 0 */
@property (assign, nonatomic) NSUInteger titleMarginHorizontalBounds;

/* use this value to change the distance between the title and top bounds, default is 0 */
@property (assign, nonatomic) NSUInteger titleMarginTopBounds;

/* default is Helvetica, 16 px */
@property (strong, nonatomic) UIFont *subtitleFont;

/* default is whiteColor */
@property (strong, nonatomic) UIColor *subtitleTextColor;

/* default is UITextAlignmentCenter */
@property (assign, nonatomic) UITextAlignment subtitleTextAlignment;

/* use this value to change the distance between the subtitle and horizontal bounds, default is 0 */
@property (assign, nonatomic) NSUInteger subtitleMarginHorizontalBounds;

/* use this value to change the distance between the subtitle and top bounds, default is 0 */
@property (assign, nonatomic) NSUInteger subtitleMarginTopBounds;

/* use this value to change the distance between the button and horizontal bounds, default is 0 */
@property (assign, nonatomic) NSUInteger buttonMarginHorizontalBounds;

/* use this value to change the distance between the button and bottom bounds, default is 0 */
@property (assign, nonatomic) NSUInteger buttonMarginBottomBounds;

/* default is whiteColor */
@property (strong, nonatomic) UIColor *buttonTextColor;

/* default is nil, and use the system's dark blue image */
@property (strong, nonatomic) UIImage *buttonBackgroundImageStateNormal;

/* default is nil, and use the system's dark blue image */
@property (strong, nonatomic) UIImage *buttonBackgroundImageStateHighlighted;

/* use this value to change the distance between the textView and horizontal bounds, default is 0 */
@property (assign, nonatomic) NSUInteger textViewMarginHorizontalBounds;

/* use this value to change the distance between the textView and top bounds, default is 0 */
@property (assign, nonatomic) NSUInteger textViewMarginTopBounds;

/* default is Helvetica, 16 px */
@property (strong, nonatomic) UIFont *textViewFont;

/* default is blackColor */
@property (strong, nonatomic) UIColor *textViewTextColor;

@end

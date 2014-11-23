//
//  ASPlaceholderTextView.h
//  ASSupplement
//
//  Created by Kowloon on 12-3-6.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASPlaceholderTextView : UITextView {
@private
    BOOL __shouldDrawPlaceholder;
}

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is nil.
 */
@property (copy ,nonatomic) NSString *placeholder;

/**
 The color of the placeholder.
 
 The default is lightGrayColor.
 */
@property (strong, nonatomic) UIColor *placeholderColor;

@end

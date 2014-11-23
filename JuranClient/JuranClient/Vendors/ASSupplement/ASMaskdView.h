//
//  ASMaskdView.h
//  Network
//
//  Created by Kowloon on 12-10-18.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMaskdView : UIView

@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *strokeColor;     //default is white
@property (nonatomic) CGFloat lineWidth;                //default is 1 
@property (nonatomic) CGFloat selectedMaskPosition;     //default is the center x
@property (nonatomic) CGFloat arrowSize;                //default is 6

@end

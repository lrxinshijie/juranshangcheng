//
//  CustomSecLevelView.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelItem.h"

struct SelectLocation{
    int viewNum;
    Location index;
};

@class CustomSecLevelView;

@protocol CustomSecLevelViewDelegate <NSObject>

- (void)secondLevelView:(CustomSecLevelView *)view didClickAtIndex:(struct SelectLocation)location;

@end

@interface CustomSecLevelView : UIView

@property (assign, nonatomic) id<CustomSecLevelViewDelegate>delegate;




- (void)setTextSelectColor:(Location)loc;
- (void)setTextNormalColor:(Location)loc;

//配置View的UI的方法
- (void)initSecondLevelViewWithItem:(SecondLevelItem *)item;

@end

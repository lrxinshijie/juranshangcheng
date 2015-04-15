//
//  CustomSearchBar.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    RightBtnStyle_Scan = 0,
    RightBtnStyle_Search,
    RightBtnStyle_More
    
}RightBtnStyle;

@protocol CustomSearchBarDelegate <NSObject>

- (void)goBackButtonDidSelect;

- (void)pushToQRCodeVCDidTriggered;

@end

@interface CustomSearchBar : UIView

@property (assign, nonatomic) id<CustomSearchBarDelegate>delegate;


//初始化的时候这个方法必须调用
- (void)rightButtonChangeStyleWithKey:(RightBtnStyle)style;

@end

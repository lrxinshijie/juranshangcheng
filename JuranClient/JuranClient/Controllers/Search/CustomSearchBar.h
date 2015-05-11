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

- (void)startSearchWithKeyWord:(NSString *)keyWord index:(int)index;

- (void)showMenuList;

@end

@interface CustomSearchBar : UIView

@property (assign, nonatomic) id<CustomSearchBarDelegate>delegate;


//初始化的时候这个方法必须调用
- (void)rightButtonChangeStyleWithKey:(RightBtnStyle)style;

////设置当前的是第几页，必须在刷新前掉这个方法。
//- (void)setPageNo:(NSInteger)pageNo;

//设置输入框文字
- (void)setTextFieldText:(NSString *)text;

@end

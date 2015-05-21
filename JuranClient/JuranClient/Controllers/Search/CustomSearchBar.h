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

typedef enum {
    
    SearchButtonType_Case = 0,
    SearchButtonType_Product,
    SearchButtonType_Shop,
    SearchButtonType_Designer,
    SearchButtonType_Question
    
}SearchButtonType;

@protocol CustomSearchBarDelegate <NSObject>

//返回
- (void)goBackButtonDidSelect;

//开始搜索
- (void)startSearchWithKeyWord:(NSString *)keyWord index:(int)index;

//显示更多按钮
- (void)showMenuList;
@optional
//开始编辑
- (void)customSearchStartWork;

@end

@interface CustomSearchBar : UIView

@property (assign, nonatomic) id<CustomSearchBarDelegate>delegate;

//用于跳转至二维码页面
@property (assign, nonatomic) id parentVC;


//初始化的时候这个方法必须调用
- (void)rightButtonChangeStyleWithKey:(RightBtnStyle)style;

////设置当前的是第几页，必须在刷新前掉这个方法。
//- (void)setPageNo:(NSInteger)pageNo;

//设置输入框文字
- (void)setTextFieldText:(NSString *)text;

//设置输入文字后右侧的搜索按钮是按照什么类型搜索，取值为SearchButtonType，依次为案例、商品、商店、设计师、问答，不设置默认为案例
- (void)setSearchButtonType:(SearchButtonType)type;

//设置是否可以展示搜索范围列表，不设置默认为可以展示
- (void)setEnabled:(BOOL)enabledShow;

@end

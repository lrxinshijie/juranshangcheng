//
//  ProductFilterView.h
//  JuranClient
//
//  Created by HuangKai on 15/5/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductFilterView;
@class ProductFilterData;
@class ProductSelectedFilter;

@protocol ProductFilterViewDelegate <NSObject>

//- (void)clickProductFilterView:(ProductFilterView *)view returnData:(ProductSelectedFilter *)data IsGrid:(BOOL)isGrid;
- (void)clickProductFilterView:(ProductFilterView *)view returnData:(ProductSelectedFilter *)data IsGrid:(BOOL)isGrid IsFilter:(BOOL)isFilter actionType:(FilterViewAction)action;
@end

@interface ProductFilterView : UIView

@property (nonatomic, assign) NSInteger xMargin;
@property (nonatomic, assign) id<ProductFilterViewDelegate> delegate;
@property (nonatomic, assign) ProductFilterData *defaultData;

-(id)initWithDefaultData:(ProductFilterData *)defaultData SeletedData:(ProductSelectedFilter*)seletedData;

- (void)showSort;
- (BOOL)isShow;

@end

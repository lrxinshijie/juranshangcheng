//
//  ProductCategaryViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/5/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class ProductFilterData;
@class ProductSelectedFilter;
typedef void (^FilterSelected)(ProductSelectedFilter *filter);
@interface ProductCategaryViewController : ALViewController
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;
@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, copy) FilterSelected block;

- (void)setBlock:(FilterSelected)block;
@end

@class ProductCategory;
@interface CatButton : UIButton
@property (nonatomic, strong) ProductCategory *category;

@end
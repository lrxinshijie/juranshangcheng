//
//  ProductListViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class ProductFilterData;
@class ProductSelectedFilter;
@class JRShop;
@class ProductBrand;

@interface ProductListViewController : ALViewController

@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;

@property (nonatomic, strong) JRShop *shop;
@property (nonatomic, strong) ProductBrand *brand;
@property (nonatomic, copy) NSString *searchKey;

@end

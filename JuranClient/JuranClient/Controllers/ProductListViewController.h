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

@interface ProductListViewController : ALViewController
@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;
@end

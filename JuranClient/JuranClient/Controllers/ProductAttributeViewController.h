//
//  ProductAttributeViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/5/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class ProductFilterData;
@class ProductSelectedFilter;
@class ProductAttribute;
typedef void (^FilterSelected)(ProductSelectedFilter *filter);
@interface ProductAttributeViewController : ALViewController
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;
@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, copy) FilterSelected block;

@property (nonatomic,strong) ProductAttribute *currentAttr;

- (void)setBlock:(FilterSelected)block;
@end

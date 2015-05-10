//
//  ProductFilterViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class ProductFilterData;
@class ProductSelectedFilter;
@class ProductStore;

typedef void (^FilterSelected)(ProductSelectedFilter *filter);

@interface ProductFilterViewController : ALViewController

@property (nonatomic, copy) FilterSelected block;

@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;

- (void)setBlock:(FilterSelected)block;

- (instancetype)initWithKeyword:(NSString *)keyword
                           Sort:(int)sort
                          Store:(ProductStore *)store
                       IsInShop:(BOOL)isInShop
                         ShopId:(long)shopId;
@end

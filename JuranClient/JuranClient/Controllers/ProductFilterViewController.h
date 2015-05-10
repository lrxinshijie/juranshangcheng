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

@interface ProductFilterViewController : ALViewController

@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;

- (instancetype)initWithKeyword:(NSString *)keyword
                           Sort:(int)sort
                          Store:(ProductStore *)store
                       IsInShop:(BOOL)isInShop;
@end

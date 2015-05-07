//
//  ProductFilterViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class ProductCategory;
@class ProductClass;
@class ProductBrand;



@interface ProductFilterViewController : ALViewController
- (instancetype)initWithKeyword:(NSString *)keyword IsInShop:(BOOL)isInShop;
@end

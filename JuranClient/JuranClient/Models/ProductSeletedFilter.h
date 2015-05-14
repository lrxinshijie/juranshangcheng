//
//  ProductSeletedFilter.h
//  JuranClient
//
//  Created by 彭川 on 15/5/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductCategory;
@class ProductClass;
@class ProductBrand;
@class ProductStore;

@interface ProductSelectedFilter : NSObject<NSCopying>
@property (nonatomic, assign) BOOL isInShop;
@property (nonatomic, assign) int sort;
//@property (nonatomic, strong) ProductSort *pSort;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) long shopId;
@property (nonatomic, strong) ProductCategory *pCategory;
@property (nonatomic, strong) ProductClass *pClass;
@property (nonatomic, strong) ProductBrand *pBrand;
@property (nonatomic, strong) ProductStore *pStore;
@property (nonatomic, assign) long pMinPrice;
@property (nonatomic, assign) long pMaxPrice;
@property (nonatomic, strong) NSMutableDictionary *pAttributeDict;
@end

//------------------------------------------------------------------
@interface ProductFilterData : NSObject
@property (nonatomic, strong) NSArray *sortList;
@property (nonatomic, strong) NSArray *attributeList;
@property (nonatomic, strong) NSArray *categoryList;
@property (nonatomic, strong) NSArray *brandList;
@property (nonatomic, strong) NSArray *storeList;
@property (nonatomic, strong) NSArray *classList;

- (void)loadFilterDataWithFilter:(ProductSelectedFilter *)filter
                         Handler:(BOOLBlock)finished;
@end
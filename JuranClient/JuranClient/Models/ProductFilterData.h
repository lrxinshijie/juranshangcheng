//
//  ProductFilterData.h
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductAttribute : NSObject
@property (nonatomic, copy) NSString *attName;
@property (nonatomic, copy) NSString *attId;
@property (nonatomic, copy) NSArray *attValues;
@end
//------------------------------------------------------------------
@interface ProductCategory : NSObject
//inshop
@property (nonatomic, assign) long Id;
@property (nonatomic, assign) long shopId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int depth;
@property (nonatomic, assign) long parentId;
//all
@property (nonatomic, copy) NSString *catCode;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, copy) NSString *parentCode;
@property (nonatomic, copy) NSString *urlContent;
//comm
@property (nonatomic, strong) NSMutableArray *childList;
@property (nonatomic, assign) BOOL isOpen;
@end
//------------------------------------------------------------------
@interface ProductBrand : NSObject
@property (nonatomic, assign) long catCode;
@property (nonatomic, assign) long brandId;
@property (nonatomic, copy) NSString *brandName;
@end
//------------------------------------------------------------------
@interface ProductStore : NSObject
@property (nonatomic, copy) NSString *storeCode;
@property (nonatomic, copy) NSString *storeName;
@end
//------------------------------------------------------------------
@interface ProductClass : NSObject
@property (nonatomic, copy) NSString *classCode;
@property (nonatomic, copy) NSString *className;
@end
//------------------------------------------------------------------
@interface ProductSelectedFilter : NSObject
@property (nonatomic, assign) BOOL isInShop;
@property (nonatomic, assign) int sort;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) long shopId;
@property (nonatomic, strong) ProductCategory *pCategory;
@property (nonatomic, strong) ProductClass *pClass;
@property (nonatomic, strong) ProductBrand *pBrand;
@property (nonatomic, assign) long pMinPrice;
@property (nonatomic, assign) long pMaxPrice;
@property (nonatomic, strong) NSArray *attributeList;
@end
//------------------------------------------------------------------
@interface ProductFilterData : NSObject
@property (nonatomic, strong) NSArray *attributeList;
@property (nonatomic, strong) NSArray *categoryList;
@property (nonatomic, strong) NSArray *brandList;
@property (nonatomic, strong) NSArray *storeList;
@property (nonatomic, strong) NSArray *classList;

- (void)loadFilterDataWithFilter:(ProductSelectedFilter *)filter
                         Handler:(BOOLBlock)finished;
@end

//{"id":71,"saleRegionId":1,"saleRegionNmae":null,"catCode":"00000101","catCodeShow":null,"catName":"建材","parentId":null,"parentCode":"-1","isEcShow":"1","isLeaf":"0","pinYin":"J","catImage":null,"image":null,"status":"1","urlContent":"21323"}


//"appShopCatList":[{"sort":2,"id":92,"shopId":18,"name":"家居","depth":1,"parentId":null}
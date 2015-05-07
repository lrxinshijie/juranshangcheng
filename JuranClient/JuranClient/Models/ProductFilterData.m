//
//  ProductFilterData.m
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductFilterData.h"

@implementation ProductAttribute
- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.attName = [dict getStringValueForKey:@"attName" defaultValue:@""];
        self.attId = [dict getStringValueForKey:@"attId" defaultValue:@""];
        self.attValues = [dict getArrayValueForKey:@"attValue" defaultValue:@[]];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductAttribute *s = [[ProductAttribute alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductCategory
- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.Id = [dict getLongValueForKey:@"id" defaultValue:0];
        self.shopId = [dict getLongValueForKey:@"shopId" defaultValue:0];
        self.name = [dict getStringValueForKey:@"catName" defaultValue:@""];
        self.depth = [dict getIntValueForKey:@"depth" defaultValue:0];
        self.parentId = [dict getLongValueForKey:@"parentId" defaultValue:0];
        self.parentCode = [dict getStringValueForKey:@"parentCode" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductCategory *s = [[ProductCategory alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductBrand
- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.catCode = [dict getLongValueForKey:@"operatingCatCode" defaultValue:0];
        self.brandId = [dict getLongValueForKey:@"brandId" defaultValue:0];
        self.brandName = [dict getStringValueForKey:@"brandName" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductBrand *s = [[ProductBrand alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductStore
- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.storeCode = [dict getStringValueForKey:@"storeCode" defaultValue:@""];
        self.storeName = [dict getStringValueForKey:@"storeName" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductStore *s = [[ProductStore alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductClass
- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.classCode = [dict getStringValueForKey:@"catCode" defaultValue:@""];
        self.className = [dict getStringValueForKey:@"catName" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductClass *s = [[ProductClass alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end

@implementation ProductFilterData
- (void)loadFilterDataWithIsInShop:(BOOL)isInShop
                              Sort:(int)sort
                           Keyword:(NSString *)keyword
                          MinPrice:(long)minPrice
                          MaxPrice:(long)maxPrice
                            Brands:(NSString *)brands
                        Attributes:(NSString *)attributes
                         StoreCode:(NSString *)storeCode
                            ShopId:(long)shopId
                      ShopCategory:(long)shopCat
                           Handler:(BOOLBlock)finished{
//    NSDictionary *param = @:,

//                            @"brands":brands,
//                            @"attributes":attributes,
//                            @"shopId":
//                            @"shopCategories":
//                            };
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"北京市" forKey:@"cityName"];
    [param setObject:@(1) forKey:@"pageNo"];
    [param setObject:@(1) forKey:@"onePageCount"];
    [param setObject:@(sort) forKey:@"sort"];
    if (keyword) [param setObject:keyword forKey:@"keyword"];
    if (minPrice!=0) [param setObject:[NSString stringWithFormat:@"%ld",minPrice<=maxPrice?minPrice:maxPrice] forKey:@"priceMinYuan"];
    if (maxPrice!=0) [param setObject:[NSString stringWithFormat:@"%ld",minPrice>maxPrice?minPrice:maxPrice] forKey:@"priceMaxYuan"];
    if (brands) [param setObject:brands forKey:@"brands"];
    if (attributes) [param setObject:attributes forKey:@"attributes"];
    if (shopId!=0) [param setObject:[NSString stringWithFormat:@"%ld",shopId] forKey:@"shopId"];
    if (shopCat!=0) [param setObject:[NSString stringWithFormat:@"%ld",shopCat] forKey:@"shopCategories"];
    
    NSString *url = nil;
    if (isInShop) {
        url = JR_SEARCH_PRODUCT_IN_SHOP;
    }else{
        url = JR_SEARCH_PRODUCT;
    }
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.attributeList = [ProductAttribute buildUpWithValueForList:[data objectForKey:@"showAttributesList"]];
            self.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appOperatingCatList"]];
            self.brandList = [ProductBrand buildUpWithValueForList:[data objectForKey:@"sortBrandList"]];
            self.storeList = [ProductStore buildUpWithValueForList:[data objectForKey:@"appStoreInfoList"]];
            self.categoryList = [ProductClass buildUpWithValueForList:[data objectForKey:@"appManagementCategoryList"]];
        }
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

@end

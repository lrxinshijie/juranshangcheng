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
        self.name = [dict getStringValueForKey:@"name" defaultValue:@""];
        self.depth = [dict getIntValueForKey:@"depth" defaultValue:0];
        self.parentId = [dict getLongValueForKey:@"parentId" defaultValue:-1];
        self.catCode = [dict getStringValueForKey:@"catCode" defaultValue:@""];
        self.catName = [dict getStringValueForKey:@"catName" defaultValue:@""];
        self.parentCode = [dict getStringValueForKey:@"parentCode" defaultValue:@""];
        self.urlContent = [dict getStringValueForKey:@"urlContent" defaultValue:@""];
        self.childList = [[NSMutableArray alloc]init];
        self.isOpen = NO;
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
        self.catCode = [dict getStringValueForKey:@"operatingCatCode" defaultValue:@""];
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
//------------------------------------------------------------------
@implementation ProductSort

@end
//------------------------------------------------------------------
//@implementation ProductSelectedFilter
////- (id)copyWithZone:(NSZone *)zone {
//////    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
//////    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
////    return nil;
////}
//@end
@implementation ProductFilterData
- (instancetype)init {
    self = [super init];
    if (self) {
        ProductSort *sort1 = [[ProductSort alloc]init];
        sort1.sort = 9;
        sort1.name = @"综合排序";
        ProductSort *sort2 = [[ProductSort alloc]init];
        sort2.sort = 4;
        sort2.name = @"按销量排序";
        ProductSort *sort3 = [[ProductSort alloc]init];
        sort3.sort = 3;
        sort3.name = @"价格由高到低";
        ProductSort *sort4 = [[ProductSort alloc]init];
        sort4.sort = 2;
        sort4.name = @"价格由低到高";
        self.sortList = [NSArray arrayWithObjects:sort1, sort2, sort3, sort4, nil];
    }
    return self;
}

- (void)loadFilterDataWithFilter:(ProductSelectedFilter *)filter
                         Handler:(BOOLBlock)finished{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url;
    [param setObject:@"北京市" forKey:@"cityName"];
    [param setObject:@(1) forKey:@"pageNo"];
    [param setObject:@(1) forKey:@"onePageCount"];
    [param setObject:@(filter.sort) forKey:@"sort"];
    if (filter.keyword && filter.keyword.length>0) [param setObject:filter.keyword forKey:@"keyword"];
    if (filter.pMinPrice>0) [param setObject:[NSString stringWithFormat:@"%ld",filter.pMinPrice<=filter.pMinPrice?filter.pMinPrice:filter.pMaxPrice] forKey:@"priceMinYuan"];
    if (filter.pMaxPrice>0) [param setObject:[NSString stringWithFormat:@"%ld",filter.pMinPrice>filter.pMinPrice?filter.pMinPrice:filter.pMaxPrice] forKey:@"priceMaxYuan"];
    if (filter.pBrand) [param setObject:@(filter.pBrand.brandId) forKey:@"brands"];
    if (filter.pStore) [param setObject:filter.pStore.storeCode forKey:@"storeCode"];
    if (filter.pClass) [param setObject:filter.pClass.classCode forKey:@"catCode"];
    if (filter.pAttributeDict && filter.pAttributeDict.count>0) {
        NSEnumerator * enumerator = [filter.pAttributeDict keyEnumerator];
        id object;
        NSString *attrString = @"";
        while(object = [enumerator nextObject])
        {
            id objectValue = [filter.pAttributeDict objectForKey:object];
            if(objectValue != nil)
            {
                if ([attrString isEqual:@""]) {
                    attrString = [attrString stringByAppendingString:[NSString stringWithFormat:@"%@:%@",object,objectValue]];
                }else {
                    attrString = [attrString stringByAppendingString:[NSString stringWithFormat:@";%@:%@",object,objectValue]];
                }
            }
            
        }
        //attrString = [NSString stringWithFormat:@"[%@]",attrString];
        [param setObject:attrString forKey:@"attributes"];
    }
    if(filter.isInShop) {
        if (filter.shopId!=0) [param setObject:[NSString stringWithFormat:@"%ld",filter.shopId] forKey:@"shopId"];
        if (filter.pCategory!=0) [param setObject:@(filter.pCategory.Id) forKey:@"shopCategories"];
        url = JR_SEARCH_PRODUCT_IN_SHOP;
    }else {
        if (filter.pCategory!=0) [param setObject:filter.pCategory.urlContent forKey:@"urlContent"];
        url = JR_SEARCH_PRODUCT;
    }
    
    [[ALEngine shareEngine] pathURL:url parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.attributeList = [ProductAttribute buildUpWithValueForList:[data objectForKey:@"showAttributesList"]];
            if (filter.isInShop) {
                self.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appShopCatList"]];
            }else {
                self.categoryList = [ProductCategory buildUpWithValueForList:[data objectForKey:@"appOperatingCatList"]];
            }
            self.brandList = [ProductBrand buildUpWithValueForList:[data objectForKey:@"sortBrandList"]];
            self.storeList = [ProductStore buildUpWithValueForList:[data objectForKey:@"appStoreInfoList"]];
            self.classList = [ProductClass buildUpWithValueForList:[data objectForKey:@"appManagementCategoryList"]];
        }
        if (finished) {
            finished(error == nil);
        }
    }];
}

@end

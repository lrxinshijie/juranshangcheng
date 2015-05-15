//
//  ProductSeletedFilter.m
//  JuranClient
//
//  Created by 彭川 on 15/5/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductSeletedFilter.h"
#import "ProductFilterData.h"

@implementation ProductSelectedFilter
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sort = 9;
        _pAttributeDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ProductSelectedFilter *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.isInShop = self.isInShop;
    theCopy.sort = self.sort;
    theCopy.keyword = self.keyword.copy;
    theCopy.shopId = self.shopId;
    theCopy.pCategory = self.pCategory.copy;
    theCopy.pClass = self.pClass.copy;
    theCopy.pBrand = self.pBrand.copy;
    theCopy.pStore = self.pStore.copy;
    theCopy.pMinPrice = self.pMinPrice;
    theCopy.pMaxPrice = self.pMaxPrice;
    theCopy.pAttributeDict = self.pAttributeDict.mutableCopy;
    return theCopy;
}
@end

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


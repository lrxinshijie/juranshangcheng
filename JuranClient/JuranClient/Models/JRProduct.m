//
//  JRProduct.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRProduct.h"
#import "JRStore.h"
#import "AppDelegate.h"
#import "UserLocation.h"

@implementation JRProduct

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.onSaleMinPrice = [dict getStringValueForKey:@"onSaleMinPrice" defaultValue:@""];
        self.defaultImage = [dict getStringValueForKey:@"defaultImage" defaultValue:@""];
        self.originalImg = [dict getStringValueForKey:@"originalImg" defaultValue:@""];
        self.goodsLogo = [dict getStringValueForKey:@"goodsLogo" defaultValue:@""];
        self.goodsName = [dict getStringValueForKey:@"goodsName" defaultValue:@""];
        self.linkProductId = [dict getIntValueForKey:@"linkProductId" defaultValue:0];
        self.shopId = [dict getIntValueForKey:@"shopId" defaultValue:0];
    }
    return self;
}

- (id)initWithDictionaryForCollection:(NSDictionary*)dict{
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.onSaleMinPrice = [dict getStringValueForKey:@"price" defaultValue:@""];
        self.defaultImage = [dict getStringValueForKey:@"img" defaultValue:@""];
        self.goodsName = [dict getStringValueForKey:@"goodsName" defaultValue:@""];
        self.linkProductId = [dict getIntValueForKey:@"linkProductId" defaultValue:0];
        self.isExperience = [dict getStringValueForKey:@"isExperience" defaultValue:@""];
        self.isFailure = [dict getStringValueForKey:@"isFailure" defaultValue:@""];
        self.stallInfoList = [JRStore buildUpWithValueForList:dict[@"stallInfoList"]];
        self.type = YES;
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            JRProduct *s = [[JRProduct alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}

+ (NSMutableArray*)buildUpWithValueForCollection:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            JRProduct *s = [[JRProduct alloc] initWithDictionaryForCollection:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (void)loadInfo:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId),
                            @"shopId": @(self.shopId)
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.goodsImagesList = [data getArrayValueForKey:@"goodsImagesList" defaultValue:nil];
            
//            self.goodsName = [data getStringValueForKey:@"goodsName" defaultValue:@""];
            self.priceMax = [data getStringValueForKey:@"priceMax" defaultValue:@""];
            self.priceMin = [data getStringValueForKey:@"priceMin" defaultValue:@""];
            self.type = [data getBoolValueForKey:@"type" defaultValue:NO];
            self.shopId = [data getIntValueForKey:@"shopId" defaultValue:0];
            self.shopLogo = [data getStringValueForKey:@"shopLogo" defaultValue:@""];
            self.shopName = [data getStringValueForKey:@"shopName" defaultValue:@""];
            self.score = [data getStringValueForKey:@"score" defaultValue:@""];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (void)loadDesc:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId)
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_DESC parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.pcDesc = [data getStringValueForKey:@"pcDesc" defaultValue:@""];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (void)favority:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId),
                            @"shopId": @(self.shopId),
//                            @"type": @(!self.type)
                            @"type": self.type ? @"del" : @"add"
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_FAVORITY parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.type = !self.type;
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (void)loadAttribute:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId)
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_ATTRIBUTE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.goodsAttributesInfoList = [data getArrayValueForKey:@"goodsAttributesInfoList" defaultValue:nil];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (void)loadShop:(BOOLBlock)finished{
    NSDictionary *param = @{@"shopId": @(self.shopId)
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_SHOP_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.shopLogo = data[@"logo"];
            self.shopName = data[@"shopName"];
            self.score = data[@"score"];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (void)loadStore:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId),
                            @"cityName":@"北京市"
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_SELL_STORE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSArray *stallInfoList = [data getArrayValueForKey:@"stallInfoList" defaultValue:nil];
            self.stallInfoList = [JRStore buildUpWithValueForList:stallInfoList];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (NSString *)priceString{
    if ([self.priceMin isEqual:self.priceMax])
        return [NSString stringWithFormat:@"￥%@", self.priceMin];
    else
        return [NSString stringWithFormat:@"￥%@ ~ ￥%@", self.priceMin,self.priceMax];
}

+ (BOOL)isShowPrice{
    return ApplicationDelegate.gLocation.isSuccessLocation;
}

- (void)loadAttributeList:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId)
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_BUY_ATTRIBUTE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSArray *attributeList = [data getArrayValueForKey:@"attributeList" defaultValue:nil];
            self.attributeList = attributeList;
            
            NSArray *buyAttrList = [data getArrayValueForKey:@"buyAttrList" defaultValue:nil];
            self.buyAttrList = buyAttrList;
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (BOOL)attirbuteIsEnable:(NSArray *)selected fromRow:(NSInteger)fromRow toRow:(NSInteger)toRow{
    if (self.buyAttrList.count == 0) {
        return NO;
    }
    
    if (fromRow == toRow) {
        return YES;
    }
    
    if ([selected[toRow] integerValue] >= 0) {
        return YES;
    }
    
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];
    [selected enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger value = [obj integerValue];
        if (value >= 0) {
            NSDictionary *dict = self.attributeList[idx];
            [filter setObject:dict[@"attrList"][value] forKey:dict[@"attrId"]];
        }
    }];
    
    if (filter.allKeys.count == 0) {
        return YES;
    }
    
//    NSString *key = self.attributeList[toRow]
    [_buyAttrList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *buyAttrMap = obj[@"buyAttrMap"];
        
        
    }];
    
    
    return NO;
}

@end

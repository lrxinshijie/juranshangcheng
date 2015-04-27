//
//  JRProduct.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRProduct.h"

@implementation JRProduct

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.onSaleMinPrice = [dict getStringValueForKey:@"onSaleMinPrice" defaultValue:@""];
        self.defaultImage = [dict getStringValueForKey:@"defaultImage" defaultValue:@""];
        self.goodsLogo = [dict getStringValueForKey:@"goodsLogo" defaultValue:@""];
        self.goodsName = [dict getStringValueForKey:@"goodsName" defaultValue:@""];
        self.linkProductId = [dict getIntValueForKey:@"linkProductId" defaultValue:0];
        self.shopId = [dict getIntValueForKey:@"shopId" defaultValue:0];
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
            self.shopLogo = data[@"shopLogo"];
            self.shopName = data[@"shopName"];
            self.score = data[@"score"];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

- (void)loadStore:(BOOLBlock)finished{
    NSDictionary *param = @{@"linkProductId": @(self.linkProductId)
                            };
    [[ALEngine shareEngine] pathURL:JR_PRODUCT_SELL_STORE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.shopAddDtoList = [data getArrayValueForKey:@"shopAddDtoList" defaultValue:nil];
        }
        
        if (finished) {
            finished(error == nil);
        }
        
    }];
}

@end

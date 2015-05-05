//
//  JRShop.m
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRShop.h"
#import "JRStore.h"

@implementation JRShop

- (id)init{
    self = [super init];
    if (self) {
        self.stallInfoList = @[];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.shopId = [dict getIntValueForKey:@"shopId" defaultValue:0];
        id shopInfo = dict[@"shopInfo"];
        if (shopInfo && [shopInfo isKindOfClass:[NSDictionary class]]) {
            self.shopLogo = [shopInfo getStringValueForKey:@"shopLogo" defaultValue:@""];
            self.indexShopLogo = [shopInfo getStringValueForKey:@"indexShopLogo" defaultValue:@""];
        }
        self.shopDsr = [dict getStringValueForKey:@"shopDsr" defaultValue:@""];
        self.isStored = [dict getBoolValueForKey:@"isStored" defaultValue:NO];
        if (_shopLogo.length == 0) {
            self.shopLogo = [dict getStringValueForKey:@"shopLogo" defaultValue:@""];
        }
        
        self.shopName = [dict getStringValueForKey:@"shopName" defaultValue:@""];
    }
    return self;
}

- (void)buildUpWithDictionary:(NSDictionary *)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    id shopInfo = dict[@"shopInfo"];
    if (shopInfo && [shopInfo isKindOfClass:[NSDictionary class]]) {
        self.shopLogo = [shopInfo getStringValueForKey:@"shopLogo" defaultValue:@""];
        self.indexShopLogo = [shopInfo getStringValueForKey:@"indexShopLogo" defaultValue:@""];
    }
    self.shopDsr = [dict getStringValueForKey:@"shopDsr" defaultValue:@""];
    self.isStored = [dict getBoolValueForKey:@"isStored" defaultValue:NO];
    if (_shopLogo.length == 0) {
        self.shopLogo = [dict getStringValueForKey:@"shopLogo" defaultValue:@""];
    }
    self.shopName = [dict getStringValueForKey:@"shopName" defaultValue:@""];
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            JRShop *s = [[JRShop alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (id)initWithDictionaryForShopList:(NSDictionary *)dict{
    if (self=[self init]) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            self.shopId = [dict getIntValueForKey:@"shopId" defaultValue:0];
            self.shopName = [dict getStringValueForKey:@"shopName" defaultValue:@""];
            self.brands = [dict getStringValueForKey:@"brands" defaultValue:@""];
            self.grade = [dict getStringValueForKey:@"grade" defaultValue:@""];
            self.logo = [dict getStringValueForKey:@"logo" defaultValue:@""];
        }
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForShopList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            JRShop *shop = [[JRShop alloc] initWithDictionaryForShopList:obj];
            [retVal addObject:shop];
        }
    }
    return retVal;
}

- (id)initWithDictionaryForCollection:(NSDictionary *)dict{
    if (self=[self init]) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            self.shopId = [dict getIntValueForKey:@"shopId" defaultValue:0];
            self.shopName = [dict getStringValueForKey:@"shopName" defaultValue:@""];
            self.brands = [dict getStringValueForKey:@"brands" defaultValue:@""];
            self.grade = [dict getStringValueForKey:@"grade" defaultValue:@""];
            self.logo = [dict getStringValueForKey:@"logo" defaultValue:@""];
            self.isStored = YES;
            self.isFailure = [dict getBoolValueForKey:@"isFailure" defaultValue:NO];
            self.isExperience = [dict getBoolValueForKey:@"isExperience" defaultValue:NO];
            self.stallInfoList = [JRStore buildUpWithValueForList:dict[@"stallInfoList"]];
        }
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForCollection:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            JRShop *shop = [[JRShop alloc] initWithDictionaryForCollection:obj];
            [retVal addObject:shop];
        }
    }
    return retVal;
}

- (void)collectionWithViewCotnroller:(UIViewController*)vc finishBlock:(VoidBlock)finish{
    NSDictionary *param = @{@"shopId": [NSString stringWithFormat:@"%d", self.shopId]
                            , @"type": self.isStored?@"del":@"add"};
    [vc showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_COLLECTION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkMessageKey:@"YES"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [vc hideHUD];
        if (!error) {
            self.isStored = !self.isStored;
            if (finish) {
                finish();
            }
        }
    }];
}

@end

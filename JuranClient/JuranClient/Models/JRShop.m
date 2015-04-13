//
//  JRShop.m
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRShop.h"

@implementation JRShop

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        id shopInfo = dict[@"shopInfo"];
        if (shopInfo && [shopInfo isKindOfClass:[NSDictionary class]]) {
            self.shopLogo = [shopInfo getStringValueForKey:@"shopLogo" defaultValue:@""];
            self.indexShopLogo = [shopInfo getStringValueForKey:@"indexShopLogo" defaultValue:@""];
        }
        self.shopDsr = [dict getStringValueForKey:@"shopDsr" defaultValue:@""];
        self.isStored = [dict getBoolValueForKey:@"isStored" defaultValue:NO];
    }
    return self;
}


@end

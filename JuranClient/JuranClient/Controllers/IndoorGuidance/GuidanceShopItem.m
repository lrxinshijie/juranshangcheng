//
//  GuidanceShopItem.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/5/27.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "GuidanceShopItem.h"

@implementation GuidanceShopItem

- (GuidanceShopItem *)initGuidanceShopItemWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        self.mid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mid"]];
        self.name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        self.summary = [NSString stringWithFormat:@"%@",[dict objectForKey:@"summary"]];
        self.province = [NSString stringWithFormat:@"%@",[dict objectForKey:@"province"]];
        self.city = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city"]];
        self.area = [NSString stringWithFormat:@"%@",[dict objectForKey:@"area"]];
        self.address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
        self.lng = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lng"]];
        self.lat = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lat"]];
        self.image = [NSString stringWithFormat:@"%@",[dict objectForKey:@"image"]];
        self.ytid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ytid"]];
        self.type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
        self.vals = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vals"]];
        self.distance = [NSString stringWithFormat:@"%@",[dict objectForKey:@"distance"]];
        self.indoorId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"indoorId"]];
        
    }
    
    return self;
}

+ (GuidanceShopItem *)createGuidanceShopItemWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initGuidanceShopItemWithDictionary:dict];
}

@end

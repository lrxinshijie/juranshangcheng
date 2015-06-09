//
//  GuidanceShopItem.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/5/27.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuidanceShopItem : NSObject

@property (strong, nonatomic)NSString * id;
@property (strong, nonatomic)NSString * mid;
@property (strong, nonatomic)NSString * name;
@property (strong, nonatomic)NSString * summary;
@property (strong, nonatomic)NSString * province;
@property (strong, nonatomic)NSString * city;
@property (strong, nonatomic)NSString * area;
@property (strong, nonatomic)NSString * address;
@property (strong, nonatomic)NSString * lng;
@property (strong, nonatomic)NSString * lat;
@property (strong, nonatomic)NSString * image;
@property (strong, nonatomic)NSString * ytid;
@property (strong, nonatomic)NSString * type;
@property (strong, nonatomic)NSString * vals;
@property (strong, nonatomic)NSString * distance;
@property (strong, nonatomic)NSString * indoorId;



+ (GuidanceShopItem *)createGuidanceShopItemWithDictionary:(NSDictionary *)dict;

@end

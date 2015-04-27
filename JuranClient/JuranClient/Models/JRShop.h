//
//  JRShop.h
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRShop : NSObject
/*
 店铺信息	业务	N	shopInfo
 店铺logo	业务	N	shopLogo
 店铺背景图	业务	N	indexShopLogo
 店铺评分	业务	N	shopDsr
 是否已收藏	业务	Y	isStored
 */

@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *shopLogo;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *indexShopLogo;
@property (nonatomic, copy) NSString *shopDsr;
@property (nonatomic, assign) BOOL isStored;
@property (nonatomic, copy) NSString *grade;
//search
@property (nonatomic, copy) NSString *brands;
@property (nonatomic, copy) NSString *logo;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)buildUpWithValueForList:(id)value;
- (id)initWithDictionaryForShopList:(NSDictionary *)dict;
+ (NSMutableArray*)buildUpWithValueForShopList:(id)value;
- (void)buildUpWithDictionary:(NSDictionary *)dict;
@end

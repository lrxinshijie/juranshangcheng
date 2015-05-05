//
//  JRProduct.h
//  JuranClient
//
//  Created by 李 久龙 on 15/4/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRProduct : NSObject

@property (nonatomic, copy) NSString *onSaleMinPrice;
@property (nonatomic, copy) NSString *defaultImage;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsLogo;
@property (nonatomic, assign) NSInteger linkProductId;
@property (nonatomic, copy) NSString *pcDesc;
@property (nonatomic, assign) NSInteger shopId;

@property (nonatomic, strong) NSArray *goodsAttributesInfoList;
@property (nonatomic, strong) NSArray *attributeList;
@property (nonatomic, strong) NSArray *goodsImagesList;
@property (nonatomic, copy) NSString *priceMax;
@property (nonatomic, copy) NSString *priceMin;
@property (nonatomic, strong) NSArray *stallInfoList;
@property (nonatomic, assign) BOOL type;

@property (nonatomic, copy) NSString *shopLogo;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *isExperience;
@property (nonatomic, copy) NSString *isFailure;


+ (NSMutableArray*)buildUpWithValueForList:(id)value;
+ (NSMutableArray*)buildUpWithValueForCollection:(id)value;

- (void)loadInfo:(BOOLBlock)finished;
- (void)loadShop:(BOOLBlock)finished;
- (void)loadDesc:(BOOLBlock)finished;
- (void)loadAttribute:(BOOLBlock)finished;
- (void)favority:(BOOLBlock)finished;
- (void)loadStore:(BOOLBlock)finished;
- (void)loadAttributeList:(BOOLBlock)finished;
@end

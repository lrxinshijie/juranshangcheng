//
//  IndoorGuidanceManager.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/5/27.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndoorGuidanceManager : NSObject

/**
 *  获得单例
 *
 *  @return 单例
 */
+ (IndoorGuidanceManager *)sharedMagager;

/**
 *  校验蓝牙是否启用
 *
 *  @param block 返回蓝牙启用状态
 */
- (void)checkOutBluetooth:(void(^)(BOOL isUsable))block;

/**
 *  保存可导航门店列表
 *
 *  @param shopList 入参，传入请求获得的可导航门店列表
 */
- (void)saveGuidanceShop:(NSArray *)shopList;

/**
 *  获得可导航门店列表
 *
 *  @return 可导航门店列表
 */
- (NSArray *)getGuidanceShop;

/**
 *  筛选可导航门店
 *
 *  @param all 所有需展示的门店
 *
 *  @return 所有需展示的门店列表，其中JRStore的couldGuidance属性被重置。此列表与入参中的all为同一列表，只是修改了参数。
 */
- (NSArray *)filterGuidingShopfrom:(NSArray *)all;

/**
 *  缓存数据
 *
 *  @param str 需要缓存的数据
 */
- (void)cacheGuidanceList:(NSString *)str;

/**
 *  获得缓存
 *
 *  @return 缓存中的数据
 */
- (NSString *)getCache;

/**
 *  将字典转化成Json
 *
 *  @param dic 需转换的字典
 *
 *  @return 转换后的json
 */
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  获得设备型号
 *
 *  @return 设备型号
 */
- (NSString*) getDeviceType;

/**
 *  获得屏幕分辨率
 *
 *  @return 屏幕分辨率
 */
- (NSString *)getResolutionRatio;

@end

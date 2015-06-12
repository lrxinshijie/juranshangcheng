//
//  Utils.h
//  BaiduHtml5
//
//  Created by navinfoaec on 15/3/20.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "constants.h"

@class NVPoint;
@interface Utils : NSObject

// 判断APP是否第一次启动
+(BOOL)isAppFirstStart;
+(void)setAppStarted;

+(void)setCityId:(NSString*)cityId;

//+(void)setBuildingId:(NSString*)buildingId;
+(void)setIndoorId:(NSString*)indoorId;

//+(NSString*)getBuildingId;
+(NSString*)getIndoorId;


#pragma mark 获取地图数据下城市存储全路径
+(NSString*)getCityMapDataDir;

#pragma mark 获取地图数据下商场存储全路径
+(NSString*)getBuildingMapDataDir;

#pragma mark 获取当前城市业务数据存储全路径
+(NSString*)getBussinessDBFullPath;

#pragma mark 获取样式文件路径
+(NSString*)getStyleFileDir;

// 获取下载文件存储全路径
+(NSString*)getBuildingMapDataZipFullPath;
+(NSString*)getRadioMetaFullPath;
+(NSString*)getBrandLogoDir;
// 读取PSF信息文件
+(NSDictionary*)readPSFInfo;

// 读取定位元信息
+(NSDictionary*)readRadioMeta;

// 读取当前PSF版本号
+(NSString*)getLocalPsfVersion;

// 记录指定建筑的地图数据版本号
+(BOOL)savePSFVersion:(NSString*)buildingId newVersion:(NSString*)newVersion;

+ (NSUInteger) deviceSystemMajorVersion;

#pragma mark 增加或更新居然商场ID与四维图新室内ID的对应关系
+(BOOL)addMidToIndoorIdMap:(NSString*)mid indoorId:(NSString*)indoor;

#pragma mark 根据居然的室内图ID获取对应的四维图新使用的室内图ID
+(NSString*)getIndoorIdByMid:(NSString*)Mid;

//判断字符串是否为空
+(BOOL)isBlank:(NSString*)str;
+(BOOL)isNotBlank:(NSString*)str;

// all 是否包含subString
+(BOOL)isContainsSubString:(NSString*)all sub:(NSString*)subString;


+(NSString*)checkVal:(NSString**)orgVal;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString*)dict:(NSDictionary*)dict forKey:(NSString*)key;

+ (id)dict:(NSDictionary*)dict forObject:(NSString*)key;

+(void)setLocalMacAddress:(NSString*)mac;
+(NSString*)getLocalMacAddress;

+(void)setCurrentIsMapPage:(BOOL)isMapPage;
+(BOOL)currentIsMapPage;
+(NVPoint*)convertImagePosToNavPos:(double)px y:(double)py;
@end

//
//  Api.h
//  BaiduHtml5
//
//  Created by heb on 15-1-19.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionInfo : NSObject

-(id)initWith:(NSString*)url actionName:(NSString*)actionName;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *actionName;

@end

@interface Api : NSObject

@property (nonatomic, strong) ActionInfo *actionInfo;
//@property(nonatomic,copy)void (^completionHandler)();
@property(nonatomic,copy)void (^callback)(NSString *respStr);

//用来监听下载错误
@property(nonatomic,copy)void(^failureHandler)(NSError *error);


//-(void)checkMapVersionIndoorId:(NSString*)indoorId mid:(NSString*)mid mapVer:(NSString*)mapVer wifiVer:(NSString*)wifiVer;
-(void)checkMapVersionIndoorId:(NSString*)indoorId mid:(NSString*)mid mapVer:(NSString*)mapVer
                       wifiVer:(NSString*)wifiVer fmtGeoVer:(NSString*)fmtGeoVer fmtWifiVer:(NSString*)fmtWifiVer;

-(void)getArroundBuildingList:(double)wgs84Lng lati:(double)wgs84Lat distance:(double)distance storeCode:(NSString*)storeCode;
-(NSString*)getArroundBuildingListSyn:(double)wgs84Lng lati:(double)wgs84Lat distance:(double)distance storeCode:(NSString*)storeCode;

/// beacon消息推送
-(void)getPromotionByBeaconID:(NSString*)indoorId beaconIDs:(NSString*)beaconIDs lastTime:(long long)lastTime;

/// 摊位（空间单元）促销信息
-(void)getPromotionBySpaceId:(NSString*)indoorId spaceId:(NSString*)spaceId;

/// 业务数据更新
-(void)getMerchantDataUpdate:(NSString*)indoorId lastUpdateTime:(long long)time;

// 获取beacon更新列表
-(void)getBeaconDataUpdate:(NSString*)indoorId lastUpdateTime:(long long)time;

//
//-(void)uploadTrackList:(NSArray*)traceList;
-(void)uploadTrackList:(NSString*)indoorId trackeList:(NSArray*)trackeList;

-(void)searchtest;

-(void)cancelRequest;

-(void)getLocalMacAddress:(NSString*)storeCode;
//-(NSDictionary*)getLocalMacAddress;
-(NSDictionary*)getLocalMacAddressSyn:(NSString*)storeCode;

-(void)getPostionByMac:(NSString*)mac;
-(NSString*)getPostionByMacSyn:(NSString*)mac;

@end

//
//  LocationUtil.h
//  BaiduHtml5
//
//  Created by navinfoaec on 15/4/9.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationUtilDelegate <NSObject>

-(void)GetNearBuildingListFinish:(NSString*)result retCode:(NSInteger)retCode retMsg:(NSString*)retMsg;
//completion:(void (^)(NSString*result, NSInteger retCode, NSString *retMsg)
/**
 *	@brief  获取用户相关信息
 *
 *  param
 *
 *	@return 用户信息key-value
 */
-(NSDictionary*)getUserInfo;

-(void)setInnerDrawing:(BOOL)bDrawing;

@end

@protocol MapUtilDelegate <NSObject>

-(void)setInnerDrawing:(BOOL)bDrawing;

@end

@interface NVPoint : NSObject

@property(nonatomic,assign) double  lati;
@property(nonatomic,assign) double  lon;

@property(nonatomic,strong)NSString* floor;
@property(nonatomic,strong)NSString* time;

-(id)initWithLati:(double)lati Lon:(double)lon;
-(id)initWithLati:(double)lati Lon:(double)lon floor:(NSString*)floor time:(NSString*)time;
@end



@interface LocationUtil : NSObject

@property(nonatomic, assign)id<LocationUtilDelegate> delegate;
@property(nonatomic, assign)id<MapUtilDelegate> mapDelegate;


/// 获取单例对象
+ (LocationUtil *)defaultInstance;

-(void)stopService;

/// 从居然获取用户信息
-(NSDictionary*)getUserInfoFromApp;

// bDrawing: YES:开始渲染   NO:暂停渲染
-(void)setDrawing:(BOOL)bDrawing;

/// 根据用户当前GPS坐标同步获取附近商场列表
/// 如果center有值，则获取以此位置为圆心以radius为半径附近商场列表
-(NSString*)SynGetNearBuildingList:(NVPoint*)center storeCode:(NSString*)storeCode Radius:(double)radius retCode:(NSInteger *)retCode retMsg:(NSString **)retMsg;


/// 根据用户当前GPS坐标异步获取附近商场列表
/// 如果center有值，则获取此位置附近商场列表
-(NSString*)AsynGetNearBuildingList:(NVPoint*)center storeCode:(NSString*)storeCode Radius:(double)radius completion:(void (^)(NSString*result, NSInteger retCode, NSString *retMsg))completion;

/// 由代理方法
-(void)AsynGetNearBuildingList:(NVPoint*)center storeCode:(NSString*)storeCode Radius:(double)radius;

@end

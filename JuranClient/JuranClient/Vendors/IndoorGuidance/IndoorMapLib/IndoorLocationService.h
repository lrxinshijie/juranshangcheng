//
//  IndoorLocationService.h
//  IndoorMapDemo
//
//  Created by navinfoaec on 15/5/19.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LocationStatusEnum){
    LocationStatus_notSupport = -1,
    LocationStatus_stop = 0,
    // 不显示促销信息
    LocationStatus_running
};



@class NVPoint;
@class IndoorLocationService;

@protocol IndoorLocationDelegate <NSObject>

// Tells the delegate that new location data is available.
// 正在获取用户当前位置
-(void)UpdatingToLocation;
// 获取到用户当前位置
-(void)didUpdateToLocation:(NVPoint *)newLocation oldFloorName:(NSString*)floorName;
// 获取用户位置失败
-(void)didUpdateToLocationFailue:(NSString*)msg;
// 停止定位跟随
-(void)didStopToPosting;

@end
@interface IndoorLocationService : NSObject

@property(nonatomic, assign)id<IndoorLocationDelegate>  delegate;
/**
 *	@brief	获取服务运行状态
 *
 *	@return 服务运行状态
 *	-1：不支持此服务  0:服务停止状态 1：服务运行状态
 */
@property(nonatomic,assign)LocationStatusEnum status;

/**
 *	@brief	获取单例对象
 *
 *	@return 单例对象
 */
+ (IndoorLocationService *)shareInstance;

-(void)setAppKey:(NSString*)key;
/**
 *	@brief	开启室内定位
 *
 *	@return
 */
-(BOOL)startPosting;

/**
 *	@brief	关闭室内定位
 *
 *	@return
 */
-(BOOL)stopPosting;

/**
 *	@brief	获取用户当前室内位置坐标
 *
 *	@return
 */
-(NVPoint*)getCurrentIndoorLocation;

/**
 *	@brief	平稳楼层跳跃
 *
 *	@return
 */
-(NSString*)decideFloor:(NSString*)inputFloor;

@end

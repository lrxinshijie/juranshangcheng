//
//  constants.h
//  BaiduHtml5
//
//  Created by navinfoaec on 15/3/20.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "Utils.h"


#ifndef BaiduHtml5_constants_h
#define BaiduHtml5_constants_h

//#define SERVER_URL @"http://1.93.11.172:8888/blserver/service/"
//#define SERVER_URL @"http://smart.navinfo.com:8000/Mall/api/v2/sdk/"
//#define SERVER_URL @"http://211.147.91.85/blserver/api/v2/sdk/"
//#define SERVER_URL @"http://211.147.91.84:18000/blserver/api/v2/sdk/"
//#define SERVER_URL  @"http://1.93.11.172/mall/api/v3/sdk/"

#define SERVER_URL  @"http://smart.navinfo.com:8000/Mall/api/v3/sdk/"

#define SERVER_LOCATION     @"http://10.8.10.103:1235/PassivePositioningServer/getPassivePosition"
//#define SERVER_LOCATION     @"http://182.92.222.27:1235/PassivePositioningServer/getPassivePosition"

#define SERVER_GET_MAC      @"http://169.254.167.168/"

// 下载的室内图文件名
//#define     DOWNLOAD_ZIP_NAME   @"building.zip"

// PSF文件名
#define     PSF_FILE_NAME   @"index.dat"
//#define     PSF_FILE_NAME2   @"zhonghuanbailian.dat"

#define IS_IOS_8 ([Utils deviceSystemMajorVersion] >= 8)

#define funcName [NSString stringWithUTF8String:__func__]
#define funcName2  [NSString stringWithFormat:@"------%@------",funcName]
#define LOG_FUNC   NSLog(@"%@", funcName2);


#define HEIGHT_SWITCH_BTN 30
#define WIDTH_FLOOR_BTN 40
#define HEIGHT_FLOOR_BTN 30

// 顶部新地图数据包提示条的高度
#define MAP_DATA_UPDATE_TIP_VIEW_HEIGTH       30

#define CLOSE_BTN_WIDTH        23
#define CLOSE_BTN_HEIGTH        22

///  用户文档目录
#define PATH_DOCUMENT_INFO [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]

///  系统缓存目录
#define PATH_CACHE_INFO [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]

/// 保存地图数据的目录
#define PATH_MAP_DATA [PATH_CACHE_INFO stringByAppendingPathComponent:@"mht_bl"]


// 网络请求
#define RET_CODE        @"returnCode"

#define RET_PSF_VERSION @"mapver"

// 地图数据包大小，以字节为单位
#define RET_PSD_DATA_SIZE_BYTE  @"geoSize"

#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height



/// 获取附近商场列表
// 正常返回
#define RET_CODE_SUCCESS     0

// 返回新的数据
#define RET_CODE_NEWDATA    1

// 返回失败
#define RET_CODE_FALSE     -1

// 定位失败
#define RET_CODE_LOCATION_FAILUE    -2

// 未被允许定位
#define RET_CODE_DENIED     -3

#define RET_CODE_RESTRICTED      -4

#define RET_CODE_IS_RUNNING     -5

// 检查指定参数是否为空，如果为空则设置为@""
#define CHECK_STR(PARA) [Utils checkVal:(PARA)];

#define API_KEY     @"5572ce86cdc547ac85b8001f5d751426"

#define RETURN_CODE         @"returnCode"
#define SEG_MID             @"mid"
#define SEG_INDOOR_ID       @"indoorId"
#define SEG_MAP_VER         @"mapver"
#define SEG_WIFI_VER        @"wifiver"

#define SEG_PSF_FMT_VER     @"fmtGeoVer"
#define SEG_WIFI_FMT_VER    @"fmtWifiVer"

#define SEG_APP_VERSION     @"appVersion"

#define SEG_DEVICE_DPI      @"dpi"

#define SEG_KEY             @"key"
#define SEG_RECORDS         @"records"
#define SEG_MAC             @"mac"
#define SEG_USERNAME        @"username"
#define SEG_DEVICE          @"device"


#define VERSION_CHECK_METHORD   @"mapVersion"

//---
#define ibecanPullMessage       @"ibecanPullMessage"
#define SEG_BEACON_ID       @"ibecanid"
#define SEG_BEACONS         @"ibecans"

//--
#define IndoorBiz           @"indoorBiz"
#define SEG_LAST_UPDATE_TIME    @"lastTime"
//
#define SEG_TIME        @"time"


//--空间单元促销信息
#define spacePullMessage        @"spacePullMessage"
#define SEG_SPACE_ID            @"spaceId"

//-- 促销beacon消息
#define Notification_Promotion  @"Notification_Promotion"

//--轨迹上传
#define trackList               @"trackList"


#define NATIVE_PAGE_SIZE 10
#define KEY_RESPONSE_DEL_IDS @"delids"
#define KEY_RESPONSE_R_DATA @"bizData"

// 根据页码与关键字查询
#define KEY_PRESENT_RESPONSE_DATA @"KEY_PRESENT_RESPONSE_DATA"
#define KEY_RESPONSE_NATIVE_DATA @"native"
#define KEY_PRESENT_RESPONSE_STATE @"KEY_PRESENT_RESPONSE_STATE"

typedef enum {
    PRS_SUCCESS,            //!< 响应成功
    PRS_TIME_OUT,           //!< 响应超时
    PRS_ERROR,              //!< 响应错误
    PRS_NET_CONNECT_ERROR,  //!< 网络连接错误
}Present_Response_State;

// 自动开始导航
#define MAP_MODE_ROUTING        @"0"

// 高亮显示摊位
#define MAP_MODE_TAN_WEI_HIGHT_LITE @"1"

// 自动开始定位
#define MAP_MODE_POSTING_ONLY  @"2"

// 只显示地图模式
#define MAP_MODE_VIEW_ONLY      @"3"


typedef NS_ENUM(UInt8, emLocationStatus){
    // 0:未定位状态
    Location_Idling = 0,
    // 1:正在获取位置状态
    Location_Getting,
    // 2:正在跟踪定位状态
    Locating
};

// 专门用于定位位置的MARK ID
#define MARK_POSTING_ID     999999


#endif

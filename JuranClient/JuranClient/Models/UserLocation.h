//
//  UserLocation.h
//  JuranClient
//
//  Created by 彭川 on 15/4/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMKLocationService;
@class BMKGeoCodeSearch;
@class UserLocation;
typedef void (^LocationFinished)(UserLocation *loc);

@interface UserLocation : NSObject
@property (nonatomic, copy) LocationFinished block;

@property (nonatomic, assign) BOOL isSuccessLocation;//成功获取定位信息
@property (nonatomic, assign) BOOL isSuccessGeoCode;//成功编码
@property (nonatomic, assign) BOOL isSuccessReverseGeoCode;//成功反编码
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *cityName;

- (void)startLocationHandler:(LocationFinished)finished;
- (void)GeoCode:(NSString *)cityName Handler:(LocationFinished)finished;
- (void)ReverseGeoCode:(CLLocation *)location Handler:(LocationFinished)finished;

@end

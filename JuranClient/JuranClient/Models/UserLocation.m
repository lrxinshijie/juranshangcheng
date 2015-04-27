//
//  UserLocation.m
//  JuranClient
//
//  Created by 彭川 on 15/4/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "UserLocation.h"
#import <BaiduMapAPI/BMapKit.h>

@interface UserLocation()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
@end

@implementation UserLocation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = (id)self;
        _geoSearch = [[BMKGeoCodeSearch alloc]init];
        _geoSearch.delegate = (id)self;
        _isSuccessLocation = NO;
        _isSuccessGeoCode = NO;
        _isSuccessReverseGeoCode = NO;
        _location = CLLocationCoordinate2DMake(0, 0);
        _cityName = @"北京市";
    }
    return self;
}

- (void)dealloc
{
    _locService.delegate = nil;
    _geoSearch.delegate = nil;
}

- (void)startLocationHandler:(LocationFinished)finished {
    _block = finished;
    [BMKLocationService setLocationDistanceFilter:100.f];
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_locService stopUserLocationService];
    _location = userLocation.location.coordinate;
    _isSuccessLocation = YES;
    ASLog(@"定位成功,latitude=%f,longitude=%f",_location.latitude,_location.longitude);
    [self startReverseGeoCode:_location Handler:_block];
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    [_locService stopUserLocationService];
    _isSuccessLocation = NO;
    ASLog(@"定位失败");
    if (_block) {
        _block(self);
    }
}

- (void)startReverseGeoCode:(CLLocationCoordinate2D)coordinate Handler:(LocationFinished)finished{
    _block = finished;
    BMKReverseGeoCodeOption *opt = [[BMKReverseGeoCodeOption alloc]init];
    opt.reverseGeoPoint = coordinate;
    [_geoSearch reverseGeoCode:opt];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error==BMK_SEARCH_NO_ERROR) {
        if (![result.addressDetail.city isEqual:@""]) {
            _cityName = result.addressDetail.city;
            _isSuccessGeoCode = YES;
            ASLog(@"地理位置反编译成功");
        }else{
            _isSuccessGeoCode = NO;
            ASLog(@"地理位置反编译失败");
        }
    }else {
        _isSuccessGeoCode = NO;
        ASLog(@"地理位置反编译失败");
    }
    if (_block) {
        _block(self);
    }
}

- (void)startGeoCode:(NSString *)cityName Handler:(LocationFinished)finished{
    _block = finished;
    BMKGeoCodeSearchOption *opt = [[BMKGeoCodeSearchOption alloc]init];
    opt.city = cityName;
    opt.address = @"";
    [_geoSearch geoCode:opt];
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error==BMK_SEARCH_NO_ERROR) {
        _location = result.location;
        _isSuccessReverseGeoCode = YES;
        ASLog(@"地理位置编译成功");
    }else {
        _isSuccessReverseGeoCode = NO;
        ASLog(@"地理位置编译失败");
    }
    if (_block) {
        _block(self);
    }
}

@end

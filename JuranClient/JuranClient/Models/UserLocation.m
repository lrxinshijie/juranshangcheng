//
//  UserLocation.m
//  JuranClient
//
//  Created by 彭川 on 15/4/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "UserLocation.h"
#import "AppDelegate.h"
//#import <BaiduMapAPI/BMapKit.h>

@interface UserLocation()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locService;
@property (nonatomic, strong) CLGeocoder *geoService;

@end

@implementation UserLocation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _locService = [[CLLocationManager alloc]init];
        _locService.delegate = self;
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        _locService.distanceFilter = 10;
        _geoService = [[CLGeocoder alloc]init];
        //_geoSearch.delegate = self;
        _isSuccessLocation = NO;
        _isSuccessGeoCode = NO;
        _isSuccessReverseGeoCode = NO;
        _location = [[CLLocation alloc]init];
        _cityName = @"北京市";
    }
    return self;
}

- (void)requestLocation{
    if([_locService respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locService requestAlwaysAuthorization]; // 永久授权
        [_locService requestWhenInUseAuthorization]; //使用中授权
    }
}

- (void)dealloc
{
    _locService.delegate = nil;
    //_geoSearch.delegate = nil;
}

- (void)startLocationHandler:(LocationFinished)finished {
    _block = finished;
    //[BMKLocationService setLocationDistanceFilter:100.f];
    [self requestLocation];
    [_locService startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [_locService stopUpdatingLocation];
    _location = [locations lastObject];
    _isSuccessLocation = YES;
    ASLog(@"定位成功,latitude=%f,longitude=%f",_location.coordinate.latitude,_location.coordinate.longitude);
    [self ReverseGeoCode:_location Handler:_block];
}

- (void)locationManager:(CLLocationManager *)manager{
    [_locService stopUpdatingLocation];
    _isSuccessLocation = NO;
    ASLog(@"定位失败");
    if (_block) {
        _block(self);
    }
}

- (void)ReverseGeoCode:(CLLocation *)location Handler:(LocationFinished)finished{
    _block = finished;
    [_geoService reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            _isSuccessReverseGeoCode = NO;
            ASLog(@"地理位置反编码失败");
        }else {
            _isSuccessReverseGeoCode = YES;
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            NSString *name = firstPlacemark.locality;
            if ([name isEqual:@"北京市市辖区"]) {
                _cityName = @"北京市";
            }else if ([name isEqual:@"天津市市辖区"]) {
                _cityName = @"天津市";
            }else if ([name isEqual:@"上海市市辖区"]) {
                _cityName = @"上海市";
            }else if ([name isEqual:@"重庆市市辖区"]) {
                _cityName = @"重庆市";
            }else {
                _cityName = name;
            }
            ASLog(@"地理位置反编码成功,当前定位城市[%@]",_cityName);
        }
        if (_block) {
            _block(self);
        }
    }];
}

- (void)GeoCode:(NSString *)cityName Handler:(LocationFinished)finished{
    _block = finished;
    [_geoService geocodeAddressString:[NSString stringWithFormat:@"%@市政府",cityName] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            _isSuccessGeoCode = NO;
            ASLog(@"地理位置编码失败");
        }else {
            _isSuccessGeoCode = YES;
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            _location = firstPlacemark.location;
            ASLog(@"地理位置编码成功,当天城市[%@],纬度=%f,经度=%f",firstPlacemark.locality,_location.coordinate.latitude,_location.coordinate.longitude);
        }
        if (_block) {
            _block(self);
        }
    }];
}

+ (BOOL)isShowPrice{
    if (ApplicationDelegate.gLocation.isSuccessLocation && [ApplicationDelegate.gLocation.cityName isEqual:@"北京市"]) {
        return YES;
    }else {
        return NO;
    }
}
@end

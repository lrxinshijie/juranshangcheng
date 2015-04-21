//
//  LocationManager.m
//  Library
//
//  Created by Kowloon on 12-12-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "LocationManager.h"

#import "NSArray+ASCategory.h"

static const BOOL kDefaultCorrective = NO;

@interface LocationManager () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (copy, nonatomic) void (^successHandler)(CLLocation *location);
@property (copy, nonatomic) void (^failureHandler)(NSError *error);

@end

@implementation LocationManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        self.corrective = kDefaultCorrective;
        self.stopUpdatingWhenSuccess = YES;
        
        if (_corrective) {
            self.mapView = [[MKMapView alloc] init];
        } else {
            self.locationManager = [[CLLocationManager alloc] init];
        }
    }
    return self;
}

+ (LocationManager *)sharedManager
{
    static LocationManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startUpdatingLocation{
    [self startUpdatingLocationWithSuccessHandler:NULL failureHandler:NULL];
}

- (void)startUpdatingLocationWithSuccessHandler:(void (^)(CLLocation *location))successHandler
{
    [self startUpdatingLocationWithSuccessHandler:successHandler failureHandler:NULL];
}

- (void)startUpdatingLocationWithSuccessHandler:(void (^)(CLLocation *location))successHandler failureHandler:(void (^)(NSError *error))failureHandler
{
    self.successHandler = successHandler;
    self.failureHandler = failureHandler;
    
    if (_location && !_corrective) {
        if (fabs([[_location timestamp] timeIntervalSinceNow]) <= 10) {
            if (_successHandler) {
                _successHandler(_location);
            }
            return;
        }
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        if (_failureHandler) {
            _failureHandler(NULL);
        }
        return;
    }
    
    
    if (_corrective) {
        self.mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    } else {
//        self.locationManager = [[CLLocationManager alloc] init];
        if (_locationManager && _locationManager.delegate == nil) {
            _locationManager.delegate = self;
            [_locationManager startUpdatingLocation];
        }
        
    }
}

- (void)stopUpdatingLocation
{
    if (_corrective) {
        if (_mapView) {
            _mapView.delegate = nil;
            _mapView.showsUserLocation = NO;
        }
    } else {
        if (_locationManager) {
            _locationManager.delegate = nil;
            [_locationManager stopUpdatingLocation];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

/* For iOS 6 and above. */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (![self stopFromLocation:[locations lastObject]]) {
        return;
    }
    
    [self stopUpdatingLocationWhenSuccess];
    
    if (_successHandler) {
        _successHandler(_location);   
    }
}

/* For iOS 6 below */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (![self stopFromLocation:newLocation]) {
        return;
    }
    
    [self stopUpdatingLocationWhenSuccess];
    
    if (_successHandler) {
        _successHandler(_location);
    }
}

- (BOOL)stopFromLocation:(CLLocation *)location{
    if (fabs([[location timestamp] timeIntervalSinceNow]) <= 10) {
        self.location = location;
        return YES;
    }
    
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopUpdatingLocationWhenSuccess];
    
    if (_failureHandler) {
        _failureHandler(error);
    }
}

- (void)stopUpdatingLocationWhenSuccess{
    if (_stopUpdatingWhenSuccess) {
        [self stopUpdatingLocation];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (![self stopFromLocation:userLocation.location]) {
        return;
    }
    
    [self stopUpdatingLocationWhenSuccess];
    
    if (_successHandler) {
        _successHandler(_location);
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
    [self stopUpdatingLocationWhenSuccess];
    
    if (_failureHandler) {
        _failureHandler(error);
    }
}

- (void)setCorrective:(BOOL)corrective{
    _corrective = corrective;
    
    if (_corrective) {
        if (!_mapView) {
            self.mapView = [[MKMapView alloc] init];
        }
    }else if (!_locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
}

@end

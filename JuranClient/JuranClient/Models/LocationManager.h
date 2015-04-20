//
//  LocationManager.h
//  Library
//
//  Created by Kowloon on 12-12-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationManager : NSObject

// A Boolean value indicating whether the LocationManager return the corrective location. Default is NO.
@property (nonatomic) BOOL corrective;

// A Boolean value indicating whether the LocationManager will stopUpdatingLocation when get the first location successfully. Default is YES.
@property (nonatomic) BOOL stopUpdatingWhenSuccess;

@property (nonatomic, strong) CLLocation *location;

+ (LocationManager *)sharedManager;

- (void)startUpdatingLocationWithSuccessHandler:(void (^)(CLLocation *location))successHandler;
- (void)startUpdatingLocationWithSuccessHandler:(void (^)(CLLocation *location))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

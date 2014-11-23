//
//  CLLocation+ASCategory.m
//  BusOnline
//
//  Created by Kowloon on 13-9-9.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "CLLocation+ASCategory.h"

@implementation CLLocation (ASCategory)

- (NSDictionary *)dictionaryValue{
    return @{@"latitude": [NSNumber numberWithDouble:self.coordinate.latitude],
             @"longitude": [NSNumber numberWithDouble:self.coordinate.longitude],
             @"timestamp": [NSNumber numberWithDouble:[self.timestamp timeIntervalSince1970]],
             @"speed": [NSNumber numberWithDouble:self.speed],
             @"course": [NSNumber numberWithDouble:self.course],
             @"horizontalAccuracy": [NSNumber numberWithDouble:self.horizontalAccuracy],
             @"verticalAccuracy": [NSNumber numberWithDouble:self.verticalAccuracy],
             @"altitude": [NSNumber numberWithDouble:self.altitude],
             };
}

+ (CLLocation *)locationFromDictionary:(NSDictionary *)dictionary{
    
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([[dictionary objectForKey:@"latitude"] doubleValue], [[dictionary objectForKey:@"longitude"] doubleValue])
                                          altitude:[[dictionary objectForKey:@"altitude"] doubleValue]
                                horizontalAccuracy:[[dictionary objectForKey:@"horizontalAccuracy"] doubleValue]
                                  verticalAccuracy:[[dictionary objectForKey:@"verticalAccuracy"] doubleValue]
                                            course:[[dictionary objectForKey:@"course"] doubleValue]
                                             speed:[[dictionary objectForKey:@"speed"] doubleValue]
                                         timestamp:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"timestamp"] doubleValue]]];
}

@end

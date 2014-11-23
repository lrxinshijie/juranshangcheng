//
//  CLLocation+ASCategory.h
//  BusOnline
//
//  Created by Kowloon on 13-9-9.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (ASCategory)

+ (CLLocation *)locationFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryValue;

@end

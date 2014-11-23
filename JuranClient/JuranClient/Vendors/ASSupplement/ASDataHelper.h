//
//  ASDataHelper.h
//  Supplement
//
//  Created by Kowloon on 11-11-22.
//  Copyright (c) 2011年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kExtensionPNG                       @"png"

@interface ASDataHelper : NSObject

+ (BOOL)padDeviceModel;
+ (BOOL)retinaDisplaySupported;
+ (BOOL)iOS5OrLaterRunning;
+ (NSString *)deviceModel;

+ (NSString *)formatObjectToString:(id)value;
+ (NSDictionary *)formatObjectToDictionary:(id)value;

+ (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key;

@end

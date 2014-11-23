//
//  NSObject+ASCategory.h
//  CoomixMerchant
//
//  Created by Kowloon on 12-10-25.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ASLog
#if DEBUG
#define ASLog(fmt, ...) NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ASLog(fmt, ...)
#endif
#endif

#define SystemVersionGreaterThanOrEqualTo(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define SystemVersionGreaterThanOrEqualTo5 SystemVersionGreaterThanOrEqualTo(5.0f)
#define SystemVersionGreaterThanOrEqualTo6 SystemVersionGreaterThanOrEqualTo(6.0f)
#define SystemVersionGreaterThanOrEqualTo7 SystemVersionGreaterThanOrEqualTo(7.0f)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// -------------------------- Date Format -------------------------- //
#define kExtensionPNG                       @"png"

@interface NSObject (ASCategory)

- (BOOL)padDeviceModel;
- (BOOL)retinaDisplaySupported;
- (NSString *)deviceModel;

- (NSInteger)integerValueFromValue:(id)value;
- (BOOL)boolValueFromValue:(id)value;
- (NSString *)stringValueFromValue:(id)value;
- (NSDictionary *)dictionaryValueFromValue:(id)value;

- (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key;
- (NSString *)bundleVersion;


@end

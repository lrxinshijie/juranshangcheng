//
//  ASDataHelper.m
//  Supplement
//
//  Created by Kowloon on 11-11-22.
//  Copyright (c) 2011年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDataHelper.h"

// -------------------------- Device Model -------------------------- //

#define kDeviceModel                        @"deviceModel"
#define kDeviceModelPad                     @"iPad"
#define kDeviceModelPhone                   @"iPhone"
#define kDeviceModelPod                     @"iPod touch"

@implementation ASDataHelper

+ (BOOL)padDeviceModel
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO;
}

+ (BOOL)retinaDisplaySupported
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)iOS5OrLaterRunning
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)deviceModel
{
    if ([self padDeviceModel]) {
        return kDeviceModelPad;
    } else {
        return kDeviceModelPhone;
    }
}

+ (NSString *)formatObjectToString:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if (value != nil && value != [NSNull null]) {
        return [value stringValue];
    } else {
        return [NSString string];
    }
}

+ (NSDictionary *)formatObjectToDictionary:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return [NSDictionary dictionary];
    }
}

+ (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

@end

//
//  NSDate+ASCategory.h
//  BusOnline
//
//  Created by Kowloon on 13-8-9.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

// -------------------------- Date Format -------------------------- //
#define kDateFormatYearOnly                 @"yyyy"
#define kDateFormatMonthOnly                @"MM"
#define kDateFormatTheDateTodayOnly         @"dd"
#define kDateFormatTimeOnly                 @"HH:mm:ss"
#define kDateFormatHourOnly                 @"HH"
#define kDateFormatMinuteOnly               @"mm"
#define kDateFormatChinese                  @"yyyy年MM月dd日"
#define kDateFormatNatural                  @"yyyyMMdd"
#define kDateFormatNaturalLong              @"yyyyMMddHHmmss"
#define kDateFormatHorizontalLine           @"yyyy-MM-dd"
#define kDateFormatHorizontalLineLong       @"yyyy-MM-dd HH:mm:ss"
//#define kDateFormatSlash                    @"yyyy/MM/dd"
#define kDateFormatSlash                    @"MM/dd/yyyy"
//#define kDateFormatSlashLong                @"yyyy/MM/dd HH:mm:ss"
#define kDateFormatSlashLong                @"MM/dd/yyyy HH:mm"
#define kDateFormatShortChinese             @"MM月dd日 HH:mm"

@interface NSDate (ASCategory)

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format;
+ (NSString *)thisYear;
+ (NSString *)thisMonth;
+ (NSString *)theDateToday;
+ (NSString *)thisHour;
+ (NSString *)thisMinute;
+ (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate;
+ (NSDate *)midnightDateFromDate:(NSDate *)date;
+ (NSDate *)noondayFromDate:(NSDate *)date;

+ (NSString *)genderFromIDNumber:(NSString *)number;    //male results "M", female returns "F"
+ (NSDate *)birthdayFromIDNumber:(NSString *)number;    //returns the date with format like "yyyyMMdd"

- (NSDate *)dateAfterDay:(int)day;
- (NSUInteger)daysAgo;
- (NSString *)weekString;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

- (int)year;
- (int)month;
- (int)day;
- (int)hour;
- (int)minute;
- (int)second;

- (NSString*)timestamp;
@end

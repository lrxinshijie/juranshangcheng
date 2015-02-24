//
//  NSDate+ASCategory.m
//  BusOnline
//
//  Created by Kowloon on 13-8-9.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "NSDate+ASCategory.h"

@implementation NSDate (ASCategory)

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:string];
}

+ (NSString *)thisYear
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatYearOnly];
}

+ (NSString *)thisMonth
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatMonthOnly];
}

+ (NSString *)theDateToday
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatTheDateTodayOnly];
}

+ (NSString *)thisHour
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatHourOnly];
}

+ (NSString *)thisMinute
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatMinuteOnly];
}

+ (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate
{
    NSTimeInterval timeInterval = 60 * 60 * 24 * dayInterval;
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:sinceDate];
}

+ (NSDate *)midnightDateFromDate:(NSDate *)date
{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"00:00:00";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}

+ (NSDate *)noondayFromDate:(NSDate *)date
{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"12:00:00";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}

+ (NSString *)genderFromIDNumber:(NSString *)number
{
    NSString *result = @"M";
    NSUInteger length = [number length];
    if (!([number characterAtIndex:length - 2] % 2)) {
        result = @"F";
    }
    return result;
}

+ (NSDate *)birthdayFromIDNumber:(NSString *)number
{
    NSUInteger length = [number length];
    NSString *birthday = nil;
    if (length == 18) {
        birthday = [number substringWithRange:NSMakeRange(6, 8)];
    } else if (length == 15) {
        birthday = [NSString stringWithFormat:@"%d%@",19,[number substringWithRange:NSMakeRange(6, 6)]];
    }
    return [self dateFromString:birthday dateFormat:kDateFormatNatural];
}

- (NSString*)timestamp{
    NSString *retVal = nil;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, [self timeIntervalSince1970]);
    
    //    NSLog(@"distance:%d,now:%qi,%qi",distance,now,[dt timeIntervalSince1970]);
    NSDate *today = [NSDate dateFromString:[[NSDate date] stringWithFormat:@"yyyy-MM-dd 00:00:00"]];
    NSDate *yesterday = [NSDate dateFromString:[[[NSDate date] dateAfterDay:-1] stringWithFormat:@"yyyy-MM-dd  00:00:00"]];
    NSDate *before = [NSDate dateFromString:[[[NSDate date] dateAfterDay:-2] stringWithFormat:@"yyyy-MM-dd  00:00:00"]];
    NSDate *thisYear = [NSDate dateFromString:[[NSDate date] stringWithFormat:@"yyyy-01-01  00:00:00"]];
    
    if (distance < 0) distance = 0;
    //    NSLog(@"ff:%.2f,%.2f,%.2f,%.2f",[self timeIntervalSinceDate:today],[self timeIntervalSinceDate:yesterday],[self timeIntervalSinceDate:before],[self timeIntervalSinceDate:thisYear]);
    if ([self timeIntervalSinceDate:today] >= 0) {
        if (distance < 60) {
            retVal = @"Just now";
//            retVal = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
        }else if (distance < 60 * 60) {
            distance = distance / 60;
            retVal = [NSString stringWithFormat:@"%d %@", distance, @"mins ago"];
        }else if (distance < 60 * 60 * 24) {
            distance = distance / 60 / 60;
            retVal = [NSString stringWithFormat:@"%d %@", distance, @"hrs ago"];
        }
    }else if ([self timeIntervalSinceDate:yesterday] >= 0){
        retVal = [NSString stringWithFormat:@"Yesterday %@", [NSDate stringFromDate:self withFormat:@"HH:mm"]];
//        retVal = [NSString stringWithFormat:@"昨天 %@",[NSDate stringFromDate:self withFormat:@"HH:mm"]];
    }else if ([self timeIntervalSinceDate:before] >= 0){
        retVal = [NSString stringWithFormat:@"2 days ago %@", [NSDate stringFromDate:self withFormat:@"HH:mm"]];
//        retVal = [NSString stringWithFormat:@"前天 %@",[NSDate stringFromDate:self withFormat:@"HH:mm"]];
    }else if ([self timeIntervalSinceDate:thisYear] >= 0){
//        retVal = [NSDate stringFromDate:self withFormat:@"MM月dd日 HH:mm"];
        retVal = [NSDate stringFromDate:self withFormat:@"MM/dd HH:mm"];
    }else {
//        retVal = [NSDate stringFromDate:self withFormat:@"yyyy-MM-dd HH:mm"];
        retVal = [NSDate stringFromDate:self withFormat:@"MM/dd/yyyy HH:mm"];
    }
    
    //    if (distance < 0) distance = 0;
    //    if (distance < 60) {
    //        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    //    }else if (distance < 60 * 60) {
    //        distance = distance / 60;
    //        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    //    }else if (distance < 60 * 60 * 24) {
    //        distance = distance / 60 / 60;
    //        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    //    }else if (distance < 60 * 60 * 24 * 2) {
    ////        distance = distance / 60 / 60 / 24;
    //        _timestamp = @"昨天";
    ////        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    //    }else if (distance < 60 * 60 * 24 * 3){
    //        _timestamp = @"前天";
    //    }else if (distance < 60 * 60 * 24 * 365) {
    ////		distance = distance / 60 / 60 / 24 / 30;
    //        _timestamp = [NSDate stringFromDate:self withFormat:@"MM月dd日 HH:mm"];
    ////        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"月前" : @"月前"];
    //	}else {
    ////		distance = distance / 60 / 60 / 24 / 365;
    //        _timestamp = [NSDate stringFromDate:self withFormat:@"yyyy-MM-dd HH:mm"];
    ////        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"年前" : @"年前"];
    //
    //	}
    return retVal;
}

- (int)year{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps year];
}
- (int)month{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps month];
}
- (int)day{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps day];
}
- (int)hour{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps hour];
}
- (int)minute{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps minute];
}
- (int)second{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return [comps second];
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */

- (NSDate *)dateAfterDay:(int)day{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setDay:day];
	NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	return dateAfterDay;
}

- (NSDate *)dateAfterMonth:(int)month{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}

- (NSString *)weekString{
	NSString *retVal = @"";
	switch ([self weekday]) {
		case 1:
			retVal =  @"Sun";
			break;
		case 2:
			retVal = @"Mon";
			break;
		case 3:
			retVal = @"Tues";
			break;
		case 4:
			retVal = @"Wed";
			break;
		case 5:
			retVal = @"Thur";
			break;
		case 6:
			retVal = @"Fri";
			break;
		case 7:
			retVal = @"Sat";
			break;
		default:
			break;
	}
	
	return retVal;//[NSString stringWithFormat:@"星期%@",retVal];
	
}

- (NSUInteger)daysAgo {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%d days ago", daysAgo];
	}
	return text;
}

- (NSUInteger)weekday {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	/*
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		if ([date compare:lastweek] == NSOrderedDescending) {
			[displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];
			if (thatYear >= thisYear) {
				[displayFormatter setDateFormat:@"MMM d"];
			} else {
				[displayFormatter setDateFormat:@"MMM d, yyyy"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];
	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}
	
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	// Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	
	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {	
	return [NSDate timestampFormatString];
}

@end

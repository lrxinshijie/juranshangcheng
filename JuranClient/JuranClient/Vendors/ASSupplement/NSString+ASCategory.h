//
//  NSString+ASCategory.h
//  PhoneOnline
//
//  Created by Kowloon on 12-10-11.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ASCategory)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
+ (NSString*)localizedString:(NSString*)key;
+ (NSString*)base64encode:(NSString*)str;
- (NSString*)timestamps;
- (NSDate *)dateFromString;
- (NSString*)md5HexDigest;
- (int)hexConvertString:(int)n;

//验证Email
- (BOOL)validateEmail;

- (BOOL)containsString:(NSString *)string;

- (NSComparisonResult)compareToVersionString:(NSString *)version;

- (NSString *)URLDecodedString;
@end

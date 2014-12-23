//
//  NSString+ASCategory.m
//  PhoneOnline
//
//  Created by Kowloon on 12-10-11.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "NSString+ASCategory.h"
#import <CommonCrypto/CommonDigest.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (ASCategory)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    CGFloat result = 0;
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size = [self sizeWithFont:font constrainedToSize:constraint];
    result = size.height;
//    ASLog("%@\t%f\t%f",self,width,result);
    return result;
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height{
    CGFloat result = 0;
    CGSize constraint = CGSizeMake(CGFLOAT_MAX, height);
    CGSize size = [self sizeWithFont:font constrainedToSize:constraint];
    result = size.width;
    return result;
}

- (int)hexConvertString:(int)n{
    int num=0;
    for(int i=0;i<[self length];i++)
    {
        int int_ch;
        
        int mult = 1;
        
        for (int s = 0; s<[self length]-i-1; s++) {
            mult *= n;
        }
        
        unichar hex_char = [self characterAtIndex:i];
        if(hex_char >= '0' && hex_char <='9')
            int_ch = (hex_char-48)*mult;
        else if(hex_char >= 'A' && hex_char <='F')
            int_ch = (hex_char-55)*mult;
        else
            int_ch = (hex_char-87)*mult;
        
        num += int_ch;
    }
    return num;
}

- (NSDate *)dateFromString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:self];
}

- (NSString*)md5HexDigest {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

+ (NSString*)base64encode:(NSString*)str
{
    if ([str length] == 0)
        return @"";
    
    const char *source = [str UTF8String];
    int strlength  = strlen(source);
    
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML
{
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [self mutableCopy];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

- (NSString*)timestamps
{
	NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt = [dateFormatter dateFromString:self];
    
    //    NSLog(@"self:%@",self);
    int distance = (int)difftime(now, [dt timeIntervalSince1970]);
    //    NSLog(@"distance:%d,now:%qi,%qi",distance,now,[dt timeIntervalSince1970]);
    if (distance < 0) distance = 0;

    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    }else if (distance < 60 * 60 * 24 * 30) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }else if (distance < 60 * 60 * 24 * 365) {
		distance = distance / 60 / 60 / 24 / 30;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"月前" : @"月前"];
	}else {
		distance = distance / 60 / 60 / 24 / 365;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"年前" : @"年前"];
		
	}
	//    else {
	//        static NSDateFormatter *dateFormatter = nil;
	//        if (dateFormatter == nil) {
	//            dateFormatter = [[NSDateFormatter alloc] init];
	//            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
	//            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	//        }
	//
	//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
	//        _timestamp = [dateFormatter stringFromDate:date];
	//    }
    return _timestamp;
}

+ (NSString*)localizedString:(NSString*)key
{
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
}

- (BOOL)validateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)containsString:(NSString *)string {
	return !NSEqualRanges([self rangeOfString:string], NSMakeRange(NSNotFound, 0));
}

// Adapted from http://snipplr.com/view/2771/compare-two-version-strings
- (NSComparisonResult)compareToVersionString:(NSString *)version {
	// Break version into fields (separated by '.')
	NSMutableArray *leftFields  = [[NSMutableArray alloc] initWithArray:[self  componentsSeparatedByString:@"."]];
	NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[version componentsSeparatedByString:@"."]];
	
	// Implict ".0" in case version doesn't have the same number of '.'
	if ([leftFields count] < [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[leftFields addObject:@"0"];
		}
	} else if ([leftFields count] > [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[rightFields addObject:@"0"];
		}
	}
	
	// Do a numeric comparison on each field
	for (NSUInteger i = 0; i < [leftFields count]; i++) {
		NSComparisonResult result = [[leftFields objectAtIndex:i] compare:[rightFields objectAtIndex:i] options:NSNumericSearch];
		if (result != NSOrderedSame) {
			return result;
		}
	}
	
	return NSOrderedSame;
}

- (NSString *)URLDecodedString {
	return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																								 (__bridge CFStringRef)self,
																								 CFSTR(""),
																								 kCFStringEncodingUTF8);
}

- (BOOL)isContainsEmoji{
    
    __block BOOL isEomji = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                isEomji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
        }
    }];
    return isEomji;
    
}

@end

//
//  JRAreaInfo.h
//  JuranClient
//
//  Created by Kowloon on 14/12/9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRAreaInfo : NSObject

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *districtName;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *districtCode;
@property (nonatomic, copy) NSString *cityCode;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryValue;

@end

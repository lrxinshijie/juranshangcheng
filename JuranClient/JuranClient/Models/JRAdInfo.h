//
//  JRAdInfo.h
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRAdInfo : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, assign) NSInteger adId;

@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *mediaCode;
@property (nonatomic, copy) NSString *mediaType;


- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

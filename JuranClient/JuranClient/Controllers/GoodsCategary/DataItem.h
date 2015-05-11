//
//  DataItem.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/23.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject


@property (strong, nonatomic) NSString * categoryCode;
@property (strong, nonatomic) NSString * imgStr;
@property (strong, nonatomic) NSString * isOrNoFatherNode;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * urlContent;





+ (DataItem *)createDataItemWithDictionary:(NSDictionary *)dict;

@end

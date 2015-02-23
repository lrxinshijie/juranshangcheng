//
//  JROrderManage.h
//  JuranClient
//
//  Created by HuangKai on 15/2/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCreditPointsDto.h"

@interface JROrderManage : NSObject

@property (nonatomic, strong) JRCreditPointsDto *capacityPointInfo;
@property (nonatomic, strong) JRCreditPointsDto *servicePointInfo;
@property (nonatomic, strong) NSMutableArray *designCreditList;

- (id)initWithDictionary:(NSDictionary *)dict;
- (void)addDesignCreditList:(id)value;

@end

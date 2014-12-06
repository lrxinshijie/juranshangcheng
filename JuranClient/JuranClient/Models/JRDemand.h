//
//  JRDemand.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDemand : NSObject

@property (nonatomic, assign) NSInteger designReqId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *houseType;
@property (nonatomic, assign) NSInteger renovationBudget;
@property (nonatomic, assign) NSInteger bidNums;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

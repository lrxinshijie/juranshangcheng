//
//  JRDemand.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JRAreaInfo;
@interface JRDemand : NSObject

@property (nonatomic, assign) NSInteger designReqId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *houseType;
@property (nonatomic, assign) NSInteger renovationBudget;
@property (nonatomic, assign) NSInteger bidNums;


@property (nonatomic, copy) NSString *contactsName;
@property (nonatomic, copy) NSString *contactsMobile;
@property (nonatomic, copy) NSString *houseArea;
@property (nonatomic, copy) NSString *budget;
@property (nonatomic, copy) NSString *budgetUnit;
@property (nonatomic, copy) NSString *renovationStyle;
@property (nonatomic, copy) NSString *neighbourhoods;
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, strong) JRAreaInfo *areaInfo;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

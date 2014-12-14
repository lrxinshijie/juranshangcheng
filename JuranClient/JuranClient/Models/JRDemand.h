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
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *houseAddress;
@property (nonatomic, assign) NSInteger houseArea;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *deadline;
@property (nonatomic, assign) NSInteger newBidNums;
@property (nonatomic, assign) BOOL isBidded;

- (NSString*)statusString;


@property (nonatomic, copy) NSString *contactsName;
@property (nonatomic, copy) NSString *contactsMobile;
@property (nonatomic, copy) NSString *budget;
@property (nonatomic, copy) NSString *budgetUnit;
@property (nonatomic, copy) NSString *renovationStyle;
@property (nonatomic, copy) NSString *neighbourhoods;
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, copy) NSString *livingroomCount;
@property (nonatomic, copy) NSString *bathroomCount;

@property (nonatomic, strong) JRAreaInfo *areaInfo;

- (NSString *)houseTypeString;
- (NSString *)renovationStyleString;
- (NSString *)roomNumString;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

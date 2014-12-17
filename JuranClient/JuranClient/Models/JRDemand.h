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

@property (nonatomic, strong) NSString *designReqId;
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


@property (nonatomic, copy) NSString *contactsName;
@property (nonatomic, copy) NSString *contactsMobile;
@property (nonatomic, copy) NSString *budget;
@property (nonatomic, copy) NSString *budgetUnit;
@property (nonatomic, copy) NSString *renovationStyle;
@property (nonatomic, copy) NSString *neighbourhoods;
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, copy) NSString *livingroomCount;
@property (nonatomic, copy) NSString *bathroomCount;
@property (nonatomic, copy) NSString *roomTypeImgUrl;

@property (nonatomic, strong) JRAreaInfo *areaInfo;

//Detail
@property (nonatomic, strong) NSString *contactsSex;
@property (nonatomic, strong) NSString *roomType;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *bidId;
@property (nonatomic, strong) NSMutableArray *bidInfoList;
@property (nonatomic, strong) NSString *deadBalance;

- (NSString*)statusString;
- (NSString *)houseTypeString;
- (NSString *)renovationStyleString;
- (NSString *)roomNumString;

+ (NSMutableArray *)buildUpWithValue:(id)value;
- (void)buildUpDetailWithValue:(id)value;

@end

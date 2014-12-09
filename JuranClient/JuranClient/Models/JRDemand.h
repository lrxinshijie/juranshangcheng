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
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *houseAddress;
@property (nonatomic, assign) NSInteger houseArea;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *deadline;
@property (nonatomic, assign) NSInteger newBidNums;
@property (nonatomic, assign) BOOL isBidded;

- (NSString*)statusString;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

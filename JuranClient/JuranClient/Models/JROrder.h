//
//  JROrder.h
//  JuranClient
//
//  Created by Kowloon on 15/2/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRAreaInfo.h"

@interface JROrder : NSObject

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *measureTid;
@property (nonatomic, copy) NSString *designTid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *measurePayAmount;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, copy) NSString *waitPayAmount;
@property (nonatomic, copy) NSString *unPaidAmount;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger decoratorId;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *decoratorMobile;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, copy) NSString *decoratorName;
@property (nonatomic, copy) NSString *levelCode;
@property (nonatomic, copy) NSString *customerHeadUrl;

@property (nonatomic, assign) BOOL ifCanCredit;
@property (nonatomic, assign) BOOL ifCanViewCredit;

@property (nonatomic, assign) BOOL ifCanDraw; //是否可提现
@property (nonatomic, assign) BOOL ifCanReDraw; //是否可取消提现
@property (nonatomic, assign) BOOL ifCanDesign;
@property (nonatomic, assign) BOOL measurefileExist;
@property (nonatomic, assign) BOOL fileExist;

@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *customerMobile;
@property (nonatomic, copy) NSString *houseArea;
@property (nonatomic, copy) NSString *addressInfo;

//Detail
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *firstPayAmount;
@property (nonatomic, copy) NSString *finalPayAmount;
@property (nonatomic, strong) NSArray *measurefileSrc;
@property (nonatomic, strong) NSArray *fileSrc;
@property (nonatomic, copy) NSString *decoratorRealName;
@property (nonatomic, copy) NSString *decoratorEmail;
@property (nonatomic, copy) NSString *decoratorWechat;

@property (nonatomic, copy) NSString *customerRealName;
@property (nonatomic, copy) NSString *customerEmail;
@property (nonatomic, copy) NSString *customerCardNo;
@property (nonatomic, copy) NSString *customerWechat;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, copy) NSString *serviceDate;

//评论
@property (nonatomic, assign) NSInteger capacityPoint;
@property (nonatomic, assign) NSInteger servicePoint;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commentGmtCreate;

//Contract
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, copy) NSString *decoratorQQ;
@property (nonatomic, copy) NSString *designReqId;
@property (nonatomic, assign) NSInteger diyPageNum;
@property (nonatomic, assign) NSInteger designPageNum;
@property (nonatomic, assign) NSInteger addPagePrice;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *customerQQ;
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, copy) NSString *livingroomNum;
@property (nonatomic, copy) NSString *bathroomNum;
@property (nonatomic, strong) JRAreaInfo *areaInfo;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) NSDictionary *roomMap;
@property (nonatomic, strong) NSDictionary *livingMap;
@property (nonatomic, strong) NSDictionary *washMap;

- (NSString *)statusName;
- (NSString *)payStatusString;
- (NSString *)houseAreaString;
- (NSString *)serviceDateString;
+ (NSMutableArray *)buildUpWithValue:(id)value;
- (void)buildUpWithValueForDetail:(id)dict;
- (void)buildUpWithValueForComment:(id)dict;
- (void)buildUpWithValueForContractInit:(id)dict;

- (NSString *)orderSpec;

- (NSString *)roomTypeString;


@end

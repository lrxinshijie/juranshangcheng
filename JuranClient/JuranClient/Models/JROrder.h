//
//  JROrder.h
//  JuranClient
//
//  Created by Kowloon on 15/2/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JROrder : NSObject

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *measureTid;
@property (nonatomic, copy) NSString *designTid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger measurePayAmount;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger payAmount;
@property (nonatomic, assign) NSInteger waitPayAmount;
@property (nonatomic, assign) NSInteger unPaidAmount;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger decoratorId;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *decoratorMobile;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, copy) NSString *decoratorName;
@property (nonatomic, copy) NSString *levelCode;

@property (nonatomic, assign) BOOL ifCanCredit;
@property (nonatomic, assign) BOOL ifCanViewCredit;

@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *customerMobile;
@property (nonatomic, copy) NSString *houseArea;
@property (nonatomic, copy) NSString *addressInfo;

//Detail
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, assign) NSInteger firstPayAmount;
@property (nonatomic, assign) NSInteger finalPayAmount;
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


- (NSString *)statusName;
- (NSString *)houseAreaString;
+ (NSMutableArray *)buildUpWithValue:(id)value;
- (void)buildUpWithValueForDetail:(id)dict;

@end

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


@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *customerMobile;
@property (nonatomic, copy) NSString *houseArea;
@property (nonatomic, copy) NSString *addressInfo;

- (NSString *)statusName;
+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

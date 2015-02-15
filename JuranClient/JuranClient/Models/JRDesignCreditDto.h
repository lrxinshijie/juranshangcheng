//
//  JRDesignCreditDto.h
//  JuranClient
//
//  Created by HuangKai on 15/2/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDesignCreditDto : NSObject

@property (nonatomic, assign) NSInteger creditID;
@property (nonatomic, assign) NSInteger consumerId;
@property (nonatomic, copy) NSString *consumerNickname;
@property (nonatomic, assign) NSInteger providerId;
@property (nonatomic, copy) NSString *providerNickname;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger capacityPoint;
@property (nonatomic, assign) NSInteger servicePoint;
@property (nonatomic, assign) NSInteger punctualityPoint;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, assign) NSInteger ifAnony;
@property (nonatomic, assign) NSInteger ifHide;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, copy) NSString *appendContent;
@property (nonatomic, copy) NSString *replyAppendContent;
@property (nonatomic, copy) NSString *ifAddCredit;

+ (NSMutableArray *)buildUpWithValue:(id)value;
- (id)initWithDictionary:(NSDictionary *)dict;

@end

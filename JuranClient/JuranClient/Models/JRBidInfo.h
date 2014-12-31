//
//  JRBidInfo.h
//  JuranClient
//
//  Created by HuangKai on 14/12/25.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JRDesigner;

@interface JRBidInfo : NSObject

@property (nonatomic, strong) JRDesigner *userBase;
@property (nonatomic, strong) NSString *biddingDeclatation;
@property (nonatomic, strong) NSString *bidId;
@property (nonatomic, strong) NSString *bidDate;
@property (nonatomic, assign) BOOL isMeasured;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

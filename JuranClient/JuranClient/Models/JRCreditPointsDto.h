//
//  JRCreditPointsDto.h
//  JuranClient
//
//  Created by HuangKai on 15/2/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCreditPointsDto : NSObject

@property (nonatomic, assign) NSInteger sellerTotal;
@property (nonatomic, assign) NSInteger sellerOneStarCredit;
@property (nonatomic, assign) NSInteger sellerTwoStarCredit;
@property (nonatomic, assign) NSInteger sellerThreeStarCredit;
@property (nonatomic, assign) NSInteger sellerFourStarCredit;
@property (nonatomic, assign) NSInteger sellerFiveStarCredit;
@property (nonatomic, assign) NSInteger averageCredit;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString*)descForDto;

@end

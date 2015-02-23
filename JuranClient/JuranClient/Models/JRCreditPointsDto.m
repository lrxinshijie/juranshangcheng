//
//  JRCreditPointsDto.m
//  JuranClient
//
//  Created by HuangKai on 15/2/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRCreditPointsDto.h"

@implementation JRCreditPointsDto

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.sellerTotal = [dict getIntValueForKey:@"sellerTotal" defaultValue:0];
        self.sellerTwoStarCredit = [dict getIntValueForKey:@"sellerTwoStarCredit" defaultValue:0];
        self.sellerTwoStarCredit = [dict getIntValueForKey:@"sellerTwoStarCredit" defaultValue:0];
        self.sellerThreeStarCredit = [dict getIntValueForKey:@"sellerThreeStarCredit" defaultValue:0];
        self.sellerFourStarCredit = [dict getIntValueForKey:@"sellerFourStarCredit" defaultValue:0];
        self.sellerFiveStarCredit = [dict getIntValueForKey:@"sellerFiveStarCredit" defaultValue:0];
        self.averageCredit = [dict getIntValueForKey:@"averageCredit" defaultValue:0];
    }
    return self;
}

- (NSString*)descForDto{
    return @"满意";
}

@end

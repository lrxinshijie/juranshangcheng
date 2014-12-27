//
//  JRBidInfo.m
//  JuranClient
//
//  Created by HuangKai on 14/12/25.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRBidInfo.h"
#import "JRDesigner.h"

@implementation JRBidInfo

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.bidId = [dict getStringValueForKey:@"bidId" defaultValue:@""];
        self.biddingDeclatation = [dict getStringValueForKey:@"biddingDeclatation" defaultValue:@""];
        self.userBase = [[JRDesigner alloc] initWithDictionaryForBidInfo:dict];
        self.bidDate = [dict getStringValueForKey:@"bidDate" defaultValue:@""];
        
    }
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRBidInfo *info = [[JRBidInfo alloc] initWithDictionary:item];
            [retVal addObject:info];
        }
    }
    return retVal;
}

@end

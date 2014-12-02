//
//  JRAdInfo.m
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRAdInfo.h"

@implementation JRAdInfo

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.key = [dict getIntValueForKey:@"id" defaultValue:0];
        self.adId = [dict getIntValueForKey:@"adId" defaultValue:0];
        
        self.link = [dict getStringValueForKey:@"link" defaultValue:@""];
        self.mediaCode = [dict getStringValueForKey:@"mediaCode" defaultValue:@""];
        self.mediaType = [dict getStringValueForKey:@"mediaType" defaultValue:@""];
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRAdInfo *s = [[JRAdInfo alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

@end

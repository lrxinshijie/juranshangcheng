//
//  JRStore.m
//  JuranClient
//
//  Created by 彭川 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JRStore.h"

@implementation JRStore
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _storeCode = [dict getStringValueForKey:@"storeCode" defaultValue:@""];
            _storeShortName = [dict getStringValueForKey:@"storeShortName" defaultValue:@""];
            _latitude = [dict getDoubleValueForKey:@"latitude" defaultValue:0];
            _longitude = [dict getDoubleValueForKey:@"longitude" defaultValue:0];
            _storeAdd = [dict getStringValueForKey:@"storeAdd" defaultValue:@""];
            _saleTime = [dict getStringValueForKey:@"saleTime" defaultValue:@""];
            _busRoute = [dict getStringValueForKey:@"busRoute" defaultValue:@""];
            _contactTelephone = [dict getStringValueForKey:@"contactTelephone" defaultValue:@""];
        }
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            JRStore *store = [[JRStore alloc]initWithDictionary:obj];
            [retVal addObject:store];
        }
    }
    return retVal;
}
@end

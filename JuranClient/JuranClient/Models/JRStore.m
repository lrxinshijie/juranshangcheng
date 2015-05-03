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

- (id)initWithDictionaryForList:(NSDictionary*)dict {
    if (self=[self init]) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            _storeCode = [dict getStringValueForKey:@"storeCode" defaultValue:@""];
            _storeName = [dict getStringValueForKey:@"storeName" defaultValue:@""];
            _latitude = [dict getDoubleValueForKey:@"latitude" defaultValue:0];
            _longitude = [dict getDoubleValueForKey:@"longitude" defaultValue:0];
            _stallCode = [dict getStringValueForKey:@"stallCode" defaultValue:@""];
            _stallName = [dict getStringValueForKey:@"stallName" defaultValue:@""];
        }
    }
    return self;
}

- (id)initWithDictionaryForInfo:(NSDictionary*)dict {
    if (self=[self init]) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
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
            JRStore *store = [[JRStore alloc]initWithDictionaryForList:obj];
            [retVal addObject:store];
        }
    }
    return retVal;
}
@end

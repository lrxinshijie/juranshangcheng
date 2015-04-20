//
//  JRStore.h
//  JuranClient
//
//  Created by 彭川 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRStore : NSObject
//navi
@property(nonatomic, copy)NSString *storeCode;
@property(nonatomic, copy)NSString *storeShortName;
@property(nonatomic, assign)double latitude;
@property(nonatomic, assign)double longitude;
//info
@property(nonatomic, copy)NSString *storeAdd;
@property(nonatomic, copy)NSString *saleTime;
@property(nonatomic, copy)NSString *busRoute;
@property(nonatomic, copy)NSString *contactTelephone;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)buildUpWithValueForList:(id)value;
@end

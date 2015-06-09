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
@property(nonatomic, copy)NSString *storeName;
@property(nonatomic, assign)double latitude;
@property(nonatomic, assign)double longitude;
@property(nonatomic, copy)NSString *stallCode;
@property(nonatomic, copy)NSString *stallName;

//是否可导航使用
@property(nonatomic, assign)BOOL couldGuidance;

//info
@property(nonatomic, copy)NSString *storeAdd;
@property(nonatomic, copy)NSString *saleTime;
@property(nonatomic, copy)NSString *busRoute;
@property(nonatomic, copy)NSString *contactTelephone;
//Indoor
@property(nonatomic, copy)NSArray *hallList;

- (id)initWithDictionaryForList:(NSDictionary *)dict;
- (id)initWithDictionaryForInfo:(NSDictionary *)dict;
+ (NSMutableArray*)buildUpWithValueForList:(id)value;
@end

@interface JRStoreHall : NSObject
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *hallCode;
@property(nonatomic, strong)NSArray *floorList;
+ (NSMutableArray*)buildUpWithValueForList:(id)value;
@end

@interface JRStoreFloor : NSObject
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *floorCode;
@property(nonatomic, strong)NSString *floorPhoto;

+ (NSMutableArray*)buildUpWithValueForList:(id)value;
@end

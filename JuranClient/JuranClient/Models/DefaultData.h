//
//  DefaultData.h
//  JuranClient
//
//  Created by 李 久龙 on 14/12/14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultData : NSObject

+ (DefaultData *)sharedData;

- (NSArray *)houseType;
- (NSArray *)renovationStyle;

- (NSArray *)roomNum;
- (NSArray *)livingroomCount;
- (NSArray *)bathroomCount;
- (NSArray *)professionalType;
- (NSArray *)style;
- (NSArray *)special;
- (NSArray*)sex;

- (id)objectForKey:(NSString *)key;
- (NSArray *)orderStatus;

- (NSNumber *)imageQuality;
- (void)setImageQuality:(NSNumber *)imageQuality;

@end

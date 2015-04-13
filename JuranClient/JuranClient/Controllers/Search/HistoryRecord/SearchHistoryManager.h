//
//  SearchHistoryManager.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DatabaseCenter.h"

@interface SearchHistoryManager : DatabaseCenter

+ (SearchHistoryManager *)sharedDataBase;

//查询
- (void)localSearchHistoryList:(void(^)(NSArray * list))block;

//插入
- (BOOL)insertSearchItem:(NSString *)str;

//删除一条
- (void)deleteSearchItem:(NSString *)str;
- (void)deleteSearchItemWith:(NSString *)str completed:(void(^)())block;

//删除全部
- (void)deleteAllLocalHistory;

@end

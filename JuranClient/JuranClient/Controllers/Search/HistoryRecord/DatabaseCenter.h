//
//  DatabaseCenter.h
//  DatabaseCenter
//
//  Created by 赵培洋 on 14/12/26.
//  Copyright (c) 2014年 huigou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseItem.h"

@interface DatabaseCenter : NSObject

@property (nonatomic, strong) FMDatabase *localDatabase;
@property (nonatomic, assign) BOOL isOpen;

/*   
 获取本地数据库存储路径
 */
- (NSString *)localDatabasePathWithDatabaseName:(NSString *)dbName;

/*
 打开关闭数据库
 */
- (BOOL)openDB:(DatabaseItem *)dbItem;
- (void)closeDB;

/*
 针对数据库需要copy的方法
 */
- (void)copyDatabaseFromPath:(NSString *)path toDatabaseName:(NSString *)dbName;

/*
 创建Table
 */
- (void)createTableWithSQLString:(NSString *)sqlStr;

/*
 更新操作
 */
- (void)updateDBWithItem:(DatabaseItem *)item
               completed:(void(^)(BOOL isCompleted))block;

/*
 查询操作
 */
- (void)asynchronousSelectDBDataWithItem:(DatabaseItem *)item
                               completed:(void(^)(NSArray * result))block;

/*
 同步查询操作
 */
- (FMResultSet *)selectSynchronousDBDataWithItem:(DatabaseItem *)item;

/*
 同步插入操作
 */
- (BOOL)updateSynchronousDBDataWithItem:(DatabaseItem *)item;


/*
 需要子类重写方法
 */
- (NSArray *)parsingSelectedResult:(FMResultSet *)result;

@end

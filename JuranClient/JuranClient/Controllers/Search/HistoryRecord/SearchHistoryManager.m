//
//  SearchHistoryManager.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "SearchHistoryManager.h"

#define DBName            @"history_db.db"
#define TableName         @"searchHistory"
#define KeyWords          @"keywords"


typedef void (^GetLocalSearchHistoryListBlock)(NSArray * listArray);
typedef void (^DeleteLocalSearchHistoryItemBlock)();

@interface SearchHistoryManager ()

@property (nonatomic,readwrite,copy) GetLocalSearchHistoryListBlock getLocalSearchHistoryListBlock;
@property (nonatomic,readwrite,copy) DeleteLocalSearchHistoryItemBlock deleteLocalSearchHistoryItemBlock;

@end

@implementation SearchHistoryManager

static SearchHistoryManager *sharedDataBase = nil;

+ (SearchHistoryManager *)sharedDataBase
{
    if (sharedDataBase != nil) {
        return sharedDataBase;
    }
    @synchronized(self)
    {
        if (sharedDataBase == nil)
        {
            sharedDataBase = [[self alloc] init];
        }
    }
    return sharedDataBase;
}

- (id)init
{
    if (self = [super init])
    {
        [self openDB];
        [self createTable];
    }
    return self;
}

- (void)dealloc
{
    [self closeDB];
}

#pragma mark 内部加载
- (BOOL)openDB
{
    if (!self.isOpen)
    {
        DatabaseItem * dItem = [[DatabaseItem alloc] init];
        dItem.dbName = DBName;
        self.isOpen = [self openDB:dItem];
    }
    return self.isOpen;
}

- (void)createTable
{
    NSString * sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ text)",TableName,KeyWords];
    [self createTableWithSQLString:sqlString];
}

#pragma mark 数据库操作
- (void)localSearchHistoryList:(void(^)(NSArray * list))block
{
    __weak SearchHistoryManager * wSelf = self;
    self.getLocalSearchHistoryListBlock = block;
    if (![self openDB])
    {
        if (self.getLocalSearchHistoryListBlock)
        {
            self.getLocalSearchHistoryListBlock(nil);
        }
        return;
    }
    DatabaseItem * dItem = [[DatabaseItem alloc] init];
    dItem.dbName = DBName;
    dItem.sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",TableName];
    [self asynchronousSelectDBDataWithItem:dItem
                                 completed:^(NSArray *result) {
                                     if (wSelf.getLocalSearchHistoryListBlock)
                                     {
                                         wSelf.getLocalSearchHistoryListBlock(result);
                                     }
                                 }];
}

- (BOOL)insertSearchItem:(NSString *)str
{
    if (![self openDB])
    {
        return NO;
    }
    DatabaseItem * dItem = [[DatabaseItem alloc] init];
    dItem.dbName = DBName;
    dItem.sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ('%@')",
                    TableName,
                    KeyWords,
                    str
                    ];
    return [self updateSynchronousDBDataWithItem:dItem];
}

- (void)deleteSearchItem:(NSString *)str
{
    if (![self openDB])
    {
        return;
    }
    
    DatabaseItem * dItem = [[DatabaseItem alloc] init];
    dItem.dbName = DBName;
    dItem.sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'",
                    TableName,
                    KeyWords,
                    str
                    ];
    [self updateSynchronousDBDataWithItem:dItem];
}

- (void)deleteSearchItemWith:(NSString *)str completed:(void(^)())block
{
    __weak SearchHistoryManager * wSelf = self;
    if (![self openDB])
    {
        return;
    }
    self.deleteLocalSearchHistoryItemBlock = block;
    if (![self openDB])
    {
        if (self.deleteLocalSearchHistoryItemBlock)
        {
            self.deleteLocalSearchHistoryItemBlock();
        }
        return;
    }
    DatabaseItem * dItem = [[DatabaseItem alloc] init];
    dItem.dbName = DBName;
    dItem.sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'",
                    TableName,
                    KeyWords,
                    str
                    ];
    [self updateDBWithItem:dItem completed:^(BOOL isSuccess){
        if (wSelf.deleteLocalSearchHistoryItemBlock)
        {
            wSelf.deleteLocalSearchHistoryItemBlock();
        }
    }];
}

- (void)deleteAllLocalHistory
{
    if (![self openDB])
    {
        return;
    }
    DatabaseItem * dItem = [[DatabaseItem alloc] init];
    dItem.dbName = DBName;
    dItem.sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",
                    TableName
                    ];
    [self updateDBWithItem:dItem completed:^(BOOL isSuccess){
        
    }];
}

#pragma mark 重写方法
- (NSArray *)parsingSelectedResult:(FMResultSet *)result
{
    NSMutableArray * resultArray = [NSMutableArray array];
    while ([result next])
    {
        NSString * str = [NSString stringWithFormat:@"%@",[result stringForColumn:KeyWords]];
        [resultArray addObject:str];
    }
    return resultArray;
}


@end

//
//  DatabaseCenter.m
//  DatabaseCenter
//
//  Created by 赵培洋 on 14/12/26.
//  Copyright (c) 2014年 huigou. All rights reserved.
//

#import "DatabaseCenter.h"

#define kBASE_PATH_DB @"JRDatabaseCache"

typedef void(^SelectDatabaseBlock)(NSArray *resultList);
typedef void(^UpdateDatabaseBlock)(BOOL isCompleted);

@interface DatabaseCenter ()

@property (nonatomic, copy) NSString *currentDBName;
@property (nonatomic, strong) NSLock *dbLock;
@property (nonatomic, copy, readwrite) SelectDatabaseBlock selectDatabaseBlock;
@property (nonatomic, copy, readwrite) UpdateDatabaseBlock updateDatabaseBlock;

@end

@implementation DatabaseCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dbLock = [[NSLock alloc] init];
        self.isOpen = NO;
    }
    return self;
}

- (void)dealloc
{
    _selectDatabaseBlock = nil;
    _updateDatabaseBlock = nil;
    [_localDatabase close];
}

- (NSString *)basePath
{
    NSString *infoPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),kBASE_PATH_DB];
    NSLog(@"FMDB--------%@",infoPath);
    //[[[UIApplication sharedApplication] documentPath] stringByAppendingPathComponent:kBASE_PATH_DB];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:infoPath isDirectory:&isDir] || !isDir) {
        [fileManager createDirectoryAtPath:infoPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return infoPath;
}

#pragma mark - 获取本地数据库存储路径
- (NSString *)localDatabasePathWithDatabaseName:(NSString *)dbName
{
    NSString *path = [[self basePath] stringByAppendingPathComponent:dbName];
    return path;
}

#pragma mark - 打开关闭数据库
- (BOOL)openDB:(DatabaseItem *)dbItem
{
    if (_isOpen) {
        return _isOpen;
    }
    self.currentDBName = dbItem.dbName;
    self.localDatabase = [FMDatabase databaseWithPath:[self localDatabasePathWithDatabaseName:dbItem.dbName]];
    self.isOpen = [self.localDatabase open];
    return self.isOpen;
}

- (void)closeDB
{
    if (_isOpen) {
        [self.localDatabase close];
        self.localDatabase = nil;
        _isOpen = NO;
    }
}

#pragma mark - 针对数据库需要copy的方法
- (void)copyDatabaseFromPath:(NSString *)path toDatabaseName:(NSString *)dbName
{
    NSString *dbPath = [self localDatabasePathWithDatabaseName:dbName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        return;
    } else {
        NSData *dbFile = [NSData dataWithContentsOfFile:path];
        [[NSFileManager defaultManager] createFileAtPath:dbPath contents:dbFile attributes:nil];
    }
}

#pragma mark - 创建Table
- (void)createTableWithSQLString:(NSString *)sqlStr
{
    [_localDatabase executeUpdate:sqlStr];
}

#pragma mark - 更新操作
- (void)updateDBWithItem:(DatabaseItem *)item
               completed:(void(^)(BOOL isCompleted))block
{
    __block BOOL isSuccessed = NO;
    self.updateDatabaseBlock = block;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (item.sqlStrArray) {
            isSuccessed = YES;
            for (int i = 0; i < item.sqlStrArray.count; i++)
            {
                [self.dbLock lock];
                BOOL isSuccess = [self.localDatabase executeUpdate:[item.sqlStrArray objectAtIndex:i]];
                [self.dbLock unlock];
                if (!isSuccess)
                {
                    isSuccessed = NO;
                }
            }
        } else if (item.sqlStr.length != 0) {
            [self.dbLock lock];
            isSuccessed = [self.localDatabase executeUpdate:item.sqlStr];
            [self.dbLock unlock];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.updateDatabaseBlock)
            {
                self.updateDatabaseBlock(isSuccessed);
            }
        });
    });
}

#pragma mark - 查询操作
- (void)asynchronousSelectDBDataWithItem:(DatabaseItem *)item
                               completed:(void(^)(NSArray * result))block
{
    self.selectDatabaseBlock = block;
    __block FMResultSet * sqlResult = nil;
    __block NSArray * resultList = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbLock lock];
        if (item.sqlStr.length != 0)
        {
            sqlResult = [self.localDatabase executeQuery:item.sqlStr];
            resultList = [NSArray arrayWithArray:[self parsingSelectedResult:sqlResult]];
            [sqlResult close];
        }
        [self.dbLock unlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.selectDatabaseBlock)
            {
                self.selectDatabaseBlock(resultList);
            }
        });
    });
}

#pragma mark - 同步查询操作
- (FMResultSet *)selectSynchronousDBDataWithItem:(DatabaseItem *)item
{
    FMResultSet * sqlResult = nil;
    if (item.sqlStr.length != 0)
    {
        [self.dbLock lock];
        sqlResult = [self.localDatabase executeQuery:item.sqlStr];
        [self.dbLock unlock];
    }
    return sqlResult;
}

#pragma mark - 同步插入操作
- (BOOL)updateSynchronousDBDataWithItem:(DatabaseItem *)item
{
    BOOL isSuccessed = NO;
    if (item.sqlStr.length != 0)
    {
        [self.dbLock lock];
        isSuccessed = [self.localDatabase executeUpdate:item.sqlStr];
        [self.dbLock unlock];
    }
    return isSuccessed;
}

#pragma mark - 需要子类重写方法
- (NSArray *)parsingSelectedResult:(FMResultSet *)result
{
    return nil;
}

@end

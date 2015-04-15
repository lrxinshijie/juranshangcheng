//
//  DatabaseItem.h
//  DatabaseCenter
//
//  Created by 赵培洋 on 14/12/26.
//  Copyright (c) 2014年 huigou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseItem : NSObject

@property (nonatomic, copy) NSString *sqlStr;
@property (nonatomic, copy) NSString *dbName;
@property (nonatomic, strong) NSMutableArray *sqlStrArray;

@end

//
//  CategaryTableViewCellItem.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategaryTableViewCellItem : NSObject

@property (strong, nonatomic) NSString * code;
@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSString * imgStr;
@property (strong, nonatomic) NSString * isOrNoFatherNode;


+ (CategaryTableViewCellItem *)createCategaryTableViewCellItemWithDictionary:(NSDictionary *)dict;


@end

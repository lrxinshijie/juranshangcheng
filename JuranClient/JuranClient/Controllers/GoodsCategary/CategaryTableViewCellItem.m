//
//  CategaryTableViewCellItem.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CategaryTableViewCellItem.h"

@implementation CategaryTableViewCellItem

- (CategaryTableViewCellItem *)initCategaryTableViewCellItemWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSString * shop_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"brandName"]];
        NSString * good_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        
        NSString * shop_code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"brandCode"]];
        NSString * good_code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"categoryCode"]];
        
        if (![shop_name  isEqual: @"(null)"] && shop_name.length != 0) {
            self.name = shop_name;
        }
        if (![good_name  isEqual: @"(null)"] && good_name.length != 0) {
            self.name = good_name;
        }
        if (![shop_code  isEqual: @"(null)"] && shop_code.length != 0) {
            self.code = shop_code;
        }
        if (![good_code  isEqual: @"(null)"] && good_code.length != 0) {
            self.code = good_code;
        }
        
        self.imgStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"imgStr"]];
        self.isOrNoFatherNode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isOrNoFatherNode"]];
        self.isSelect = NO;
    }
    return self;
}

+ (CategaryTableViewCellItem *)createCategaryTableViewCellItemWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initCategaryTableViewCellItemWithDictionary:dict];
}

@end

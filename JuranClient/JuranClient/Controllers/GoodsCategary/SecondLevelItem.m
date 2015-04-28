//
//  SecondLevelItem.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/20.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "SecondLevelItem.h"

@implementation SecondLevelItem

- (SecondLevelItem *)initSecondLevelItem
{
    self = [super init];
    if (self) {
        _isSelect = NO;
        _selectLocation = Location_None;
    }
    return self;
}

@end

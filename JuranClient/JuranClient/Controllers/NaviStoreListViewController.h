//
//  NaviStoreListViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/4/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

typedef enum : NSUInteger {
    NaviTypeStore,
    NaviTypeStall,
} NaviType;

@interface NaviStoreListViewController : ALViewController
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NaviType naviType;
@end

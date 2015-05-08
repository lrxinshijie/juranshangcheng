//
//  ProductCategaryViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/5/7.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class ProductFilterData;
@class ProductSelectedFilter;
typedef void (^FilterSelected)(ProductSelectedFilter *filter);
@interface ProductCategaryViewController : ALViewController
@property (nonatomic, strong) ProductSelectedFilter *selectedFilter;
@property (nonatomic, strong) ProductFilterData *filterData;
@property (nonatomic, copy) FilterSelected block;

- (void)setFinishBlock:(FilterSelected)finished;
@end

@interface CellOpenStatus : NSObject
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *childList;
@end
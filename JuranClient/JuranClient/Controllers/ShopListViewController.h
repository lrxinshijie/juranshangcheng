//
//  ShopListViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface ShopListViewController : ALViewController
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) int sort;
@end

//
//  OrderDetailViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/2/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
@class JROrder;

@interface OrderDetailViewController : ALViewController

@property (nonatomic, strong) JROrder *order;

@end

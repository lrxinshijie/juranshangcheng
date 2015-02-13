//
//  OrderConfirmPayViewController.h
//  JuranClient
//
//  Created by Kowloon on 15/2/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JROrder;
@interface OrderConfirmPayViewController : ALViewController

@property (nonatomic, strong) JROrder *order;

@end

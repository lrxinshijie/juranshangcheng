//
//  OrderPhotoViewController.h
//  JuranClient
//
//  Created by HuangKai on 15/2/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JROrder;
@interface OrderPhotoViewController : ALViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) JROrder *order;
@property (nonatomic, assign) BOOL needLoadData;

@end

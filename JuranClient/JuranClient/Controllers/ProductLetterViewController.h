//
//  ProductLetterViewController.h
//  JuranClient
//
//  Created by Kowloon on 15/4/20.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRProduct;
@class JRShop;
@interface ProductLetterViewController : ALViewController

@property (nonatomic, strong) JRProduct *product;
@property (nonatomic, strong) JRShop *shop;

@end

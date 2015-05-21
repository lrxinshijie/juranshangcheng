//
//  ProductDetailViewController.h
//  JuranClient
//
//  Created by 李 久龙 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRProduct;
@interface ProductDetailViewController : ALViewController

@property (nonatomic, strong) JRProduct *product;
@property (nonatomic, strong) NSMutableArray *attributeSelected;
@property (nonatomic, assign) NSInteger fromRow;

- (void)reloadPrice:(NSInteger)fromRow;

@end

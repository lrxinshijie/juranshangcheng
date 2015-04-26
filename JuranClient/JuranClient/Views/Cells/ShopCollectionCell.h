//
//  ShopCollectionCell.h
//  JuranClient
//
//  Created by HuangKai on 15/4/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRShop;

@interface ShopCollectionCell : UITableViewCell

@property (nonatomic, weak) UIViewController *viewController;

- (void)fillCellWithValue:(JRShop*)shop;

@end

//
//  ShopListCell.h
//  JuranClient
//
//  Created by 彭川 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRShop;
@interface ShopListCell : UITableViewCell
- (void)fillCellWithJRShop:(JRShop *)shop;
@end
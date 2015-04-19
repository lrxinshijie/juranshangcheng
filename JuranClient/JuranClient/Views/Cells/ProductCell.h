//
//  ProductCell.h
//  JuranClient
//
//  Created by 李 久龙 on 15/4/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRProduct;
@interface ProductCell : UITableViewCell

- (void)fillCellWithProduct:(JRProduct *)product;

@end

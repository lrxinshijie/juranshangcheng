//
//  ProductCollectionCell.h
//  JuranClient
//
//  Created by HuangKai on 15/4/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRProduct;

@interface ProductCollectionCell : UITableViewCell


- (void)fillCellWithValue:(JRProduct*)product;

@end

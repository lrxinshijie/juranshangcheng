//
//  ShopCell.h
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRProduct;

@interface ShopCell : UICollectionViewCell

- (void)fillCellWithValue:(JRProduct*)product;

@end

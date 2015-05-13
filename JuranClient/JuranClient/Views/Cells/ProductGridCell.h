//
//  ProductGridCell.h
//  JuranClient
//
//  Created by Kowloon on 15/5/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRProduct;
@interface ProductGridCell : UICollectionViewCell

- (void)fillCellWithProduct:(JRProduct *)product;

@end

//
//  TopProductCell.h
//  JuranClient
//
//  Created by Kowloon on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRProduct;
@interface TopProductCell : UICollectionViewCell

- (void)fillCellWithData:(JRProduct *)product;

@end

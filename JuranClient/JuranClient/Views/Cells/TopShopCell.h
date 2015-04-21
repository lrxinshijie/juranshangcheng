//
//  TopShopCell.h
//  JuranClient
//
//  Created by Kowloon on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRShop;
@interface TopShopCell : UICollectionViewCell

- (void)fillCellWithData:(JRShop *)shop;

@end

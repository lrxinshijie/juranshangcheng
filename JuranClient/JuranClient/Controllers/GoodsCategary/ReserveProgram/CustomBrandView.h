//
//  CustomShopView.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopViewItem.h"

@protocol CustomShopViewDelegate <NSObject>

- (void)shopViewItemDidClickWithCode:(NSString *)brandCode Name:(NSString *)brandName ID:(long)brandID;

@end

@interface CustomBrandView : UIView


@property (assign, nonatomic)id<CustomShopViewDelegate>delegate;


- (void)configViewUIWithItem:(ShopViewItem *)item;

@end

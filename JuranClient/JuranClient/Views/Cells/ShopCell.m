//
//  ShopCell.m
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ShopCell.h"
#import "JRProduct.h"

@interface ShopCell()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIImageView *defaultImageView;

@end

@implementation ShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillCellWithValue:(JRProduct *)product{
    if (!product) {
        return;
    }
    self.nameLabel.text = product.goodsName;
    [self.defaultImageView setImageWithURLString:product.defaultImage];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", product.onSaleMinPrice];
}

@end

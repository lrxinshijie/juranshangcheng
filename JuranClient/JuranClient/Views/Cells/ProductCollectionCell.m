//
//  ProductCollectionCell.m
//  JuranClient
//
//  Created by HuangKai on 15/4/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductCollectionCell.h"
#import "JRProduct.h"

@interface ProductCollectionCell()

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *collectionButton;

@end

@implementation ProductCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithValue:(JRProduct*)product{
    _nameLabel.text = product.goodsName;
    [_imgView setImageWithURLString:product.defaultImage];
    _priceLabel.text = product.onSaleMinPrice;
    
}

- (IBAction)onCollection:(id)sender{
    
}

@end

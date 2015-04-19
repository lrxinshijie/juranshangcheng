//
//  ProductCell.m
//  JuranClient
//
//  Created by 李 久龙 on 15/4/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductCell.h"
#import "JRProduct.h"

@interface ProductCell ()

@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@end

@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
    _priceLabel.textColor = kBlueColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithProduct:(JRProduct *)product{
    [_photoImageView setImageWithURLString:product.defaultImage];
    _nameLabel.text = product.productName;
    _priceLabel.text = product.onSaleMinPrice;
    
    CGRect frame = _nameLabel.frame;
    CGFloat height = [_nameLabel.text heightWithFont:_nameLabel.font constrainedToWidth:CGRectGetWidth(frame)];
    if (height >= 55) {
        height = 55;
    }
    frame.size.height = height;
    _nameLabel.frame = frame;
    
    frame = _priceLabel.frame;
    frame.origin.y = CGRectGetMaxY(_nameLabel.frame) + 5;
    _priceLabel.frame = frame;
}
@end

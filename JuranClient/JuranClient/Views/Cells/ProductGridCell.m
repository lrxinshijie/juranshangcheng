//
//  ProductGridCell.m
//  JuranClient
//
//  Created by Kowloon on 15/5/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductGridCell.h"
#import "JRProduct.h"
#import "AppDelegate.h"
#import "UserLocation.h"

@interface ProductGridCell ()

@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@end

@implementation ProductGridCell

- (void)awakeFromNib {
    // Initialization code
    
    _priceLabel.textColor = kBlueColor;
    _photoImageView.backgroundColor = RGBColor(237, 237, 237);
}

- (void)fillCellWithProduct:(JRProduct *)product{
    [_photoImageView setImageWithURLString:product.defaultImage Editing:YES];
    _titleLabel.text = product.goodsName;
    _priceLabel.text = [UserLocation isShowPrice] ? [NSString stringWithFormat:@"￥%@",product.onSaleMinPrice] : @"";
    
    CGRect frame = _titleLabel.frame;
    CGFloat height = [_titleLabel.text heightWithFont:_titleLabel.font constrainedToWidth:CGRectGetWidth(frame)];
    if (height >= 36) {
        height = 36;
    }
    frame.size.height = height;
    _titleLabel.contentMode = UIViewContentModeTop;
    _titleLabel.frame = frame;
    
    frame = _priceLabel.frame;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + 10;
    _priceLabel.contentMode = UIViewContentModeTop;
    _priceLabel.frame = frame;
}

@end

//
//  TopProductCell.m
//  JuranClient
//
//  Created by Kowloon on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "TopProductCell.h"
#import "JRProduct.h"

@interface TopProductCell ()

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end

@implementation TopProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillCellWithData:(JRProduct *)product{
    [_logoImageView setImageWithURLString:product.goodsLogo placeholderImage:nil];
    _nameLabel.text = product.goodsName;
}

@end

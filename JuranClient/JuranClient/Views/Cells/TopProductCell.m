//
//  TopProductCell.m
//  JuranClient
//
//  Created by Kowloon on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "TopProductCell.h"

@interface TopProductCell ()

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end

@implementation TopProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillCellWithData:(NSDictionary *)dict{
    [_logoImageView setImageWithURLString:dict[@"goodsLogo"]];
    _nameLabel.text = dict[@"goodsName"];
}

@end

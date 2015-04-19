//
//  TopShopCell.m
//  JuranClient
//
//  Created by Kowloon on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "TopShopCell.h"

@interface TopShopCell ()

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end

@implementation TopShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillCellWithData:(NSDictionary *)dict{
    [_logoImageView setImageWithURLString:dict[@"shopLogo"]];
    _nameLabel.text = dict[@"shopName"];
}

@end

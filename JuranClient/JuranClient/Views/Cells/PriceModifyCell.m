//
//  PriceModifyCell.m
//  JuranClient
//
//  Created by HuangKai on 15-1-9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "PriceModifyCell.h"

@implementation PriceModifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizesSubviews = NO;
        self.contentView.autoresizesSubviews = NO;
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 22, 22)];
        [self.contentView addSubview:self.iconImageView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

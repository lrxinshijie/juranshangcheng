//
//  NewestBidInfoCell.m
//  JuranClient
//
//  Created by HuangKai on 14/12/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "NewestBidInfoCell.h"
#import "JRDemand.h"

@interface NewestBidInfoCell()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) IBOutlet UILabel *bidNumsLabel;
@property (nonatomic, strong) IBOutlet UILabel *budgetLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *isBidedLabel;

@end

@implementation NewestBidInfoCell

- (void)awakeFromNib {
    // Initialization code￥
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithData:(JRDemand*)data{
    _titleLabel.text = data.title;
    _timeLabel.text = [data deadBalanceString];
    _descLabel.text = [NSString stringWithFormat:@"%@平方米 | %@", data.houseArea, data.houseAddress];
    _bidNumsLabel.text = [NSString stringWithFormat:@"已有%d人应标", data.bidNums];
    _budgetLabel.text = [NSString stringWithFormat:@"%@万元", data.budget];
    _isBidedLabel.hidden = !data.isBidded;
}

@end

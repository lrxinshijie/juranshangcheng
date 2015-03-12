//
//  NewestBidInfoCell.m
//  JuranClient
//
//  Created by HuangKai on 14/12/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "NewestBidInfoCell.h"
#import "JRDemand.h"
#import "JRAreaInfo.h"
#import "TTTAttributedLabel.h"

@interface NewestBidInfoCell()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *bidNumsLabel;
@property (nonatomic, strong) IBOutlet UILabel *budgetLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *timeImageView;
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
    _descLabel.text = [NSString stringWithFormat:@"%@㎡ | %@%@", data.houseArea, data.areaInfo.title, data.houseAddress];
    [_bidNumsLabel setText:[NSString stringWithFormat:@"已有%d人应标", data.bidNums] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%d", data.bidNums] options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
        return mutableAttributedString;
    }];
    _budgetLabel.text = [NSString stringWithFormat:@"%@万元", data.budget];
    _isBidedLabel.hidden = !data.isBidded;
    _timeLabel.hidden = [data statusIndex] > 2;
    _timeImageView.hidden = [data statusIndex] > 2;
}

@end

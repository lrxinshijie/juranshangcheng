//
//  DemandCell.m
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DemandCell.h"
#import "JRDemand.h"


@interface DemandCell()

@property (nonatomic, weak) IBOutlet UILabel *projectNumLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *styleLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *bidNumberLabel;
@property (nonatomic, weak) IBOutlet UIView *bidNumberView;

@end

@implementation DemandCell

- (void)awakeFromNib
{
    // Initialization code
    _bidNumberView.layer.masksToBounds = YES;
    _bidNumberView.layer.cornerRadius = _bidNumberView.frame.size.height/2;
    _bidNumberView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithDemand:(JRDemand*)demand{
    _projectNumLabel.text = [NSString stringWithFormat:@"项目编号：%@", demand.designReqId];
    _timeLabel.text = @"2014-10-20";
    _titleLabel.text = demand.title;
    _addressLabel.text = demand.houseAddress;
    _sizeLabel.text = [NSString stringWithFormat:@"%d平方米", demand.houseArea];
    _styleLabel.text = [demand houseTypeString];
    _priceLabel.text = [NSString stringWithFormat:@"￥%d", demand.renovationBudget/100];
    _bidNumberLabel.text = [NSString stringWithFormat:@"投标人数：%d人", demand.bidNums];
    _bidNumberView.hidden = demand.newBidNums?NO:YES;
    _statusLabel.hidden = demand.isBidded;
    _statusLabel.text = demand.isBidded?@"":[demand statusString];
    _statusImageView.image = [UIImage imageNamed:demand.isBidded?@"status_end.png":@"status_underway.png"];
}

@end

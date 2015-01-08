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

@property (nonatomic, strong) IBOutlet UIView *remarkView;
@property (nonatomic, strong) IBOutlet UILabel *remarkLabel;
@property (nonatomic, strong) IBOutlet UIImageView *remarkImageView;
@property (nonatomic, strong) IBOutlet UIButton *remarkButton;

@property (nonatomic, strong) IBOutlet UIImageView *confirmFlagImageView;

@property (nonatomic, strong) JRDemand *demand;

@end

@implementation DemandCell

- (void)awakeFromNib
{
    // Initialization code
    _bidNumberView.layer.masksToBounds = YES;
    _bidNumberView.layer.cornerRadius = _bidNumberView.frame.size.height/2;
    _bidNumberView.hidden = NO;
#ifndef kJuranDesigner
    _remarkView.hidden = YES;
    _confirmFlagImageView.hidden = YES;
#endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithDemand:(JRDemand*)demand{
    _demand = demand;
    
    _projectNumLabel.text = [NSString stringWithFormat:@"项目编号：%@", demand.designReqId];
    _timeLabel.text = demand.publishTime;
    _titleLabel.text = demand.title;
    _addressLabel.text = demand.houseAddress;
    _sizeLabel.text = [NSString stringWithFormat:@"%.2f㎡", [demand.houseArea doubleValue]];
    _styleLabel.text = [demand houseTypeString];
    _priceLabel.text = [NSString stringWithFormat:@"%@万元", demand.budget];
    _bidNumberLabel.text = [NSString stringWithFormat:@"投标人数：%d人", demand.bidNums];
    _bidNumberView.hidden = demand.newBidNums?NO:YES;
    _statusLabel.hidden = demand.isBidded;
    _statusLabel.text = demand.isBidded?@"":[demand statusString];
    _statusImageView.image = [UIImage imageNamed:demand.isBidded?@"status_end.png":@"status_underway.png"];
    NSInteger index = [demand statusIndex];
    if (index == 2) {
        if (demand.deadBalance.integerValue < 1) {
            _endTimeLabel.text = [NSString stringWithFormat:@"离结束不足1天"];
        }else{
            _endTimeLabel.text = [NSString stringWithFormat:@"离结束还有%@天", demand.deadBalance];
        }
        
    }else{
        _endTimeLabel.text = @"";
    }

#ifdef kJuranDesigner
    if (demand.memo.length == 0) {
        _remarkLabel.text = @"写备注";
        _remarkImageView.hidden = NO;
    }else{
        _remarkLabel.text = demand.memo;
        _remarkImageView.hidden = YES;
    }
    
    CGRect frame = _remarkLabel.frame;
    frame.size.height = [_remarkLabel.text heightWithFont:_remarkLabel.font constrainedToWidth:CGRectGetWidth(_remarkLabel.frame)];
    _remarkLabel.frame = frame;
    
    frame = _remarkView.frame;
    frame.size.height = CGRectGetMaxY(_remarkLabel.frame) + 5;
    _remarkView.frame = frame;
    
    frame = _remarkButton.frame;
    frame.size.height = CGRectGetHeight(_remarkView.frame);
    _remarkButton.frame = frame;
    
#endif
    
}

- (IBAction)onRemark:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(editRemark:AndDemand:)]) {
        [_delegate editRemark:self AndDemand:_demand];
    }
}

@end

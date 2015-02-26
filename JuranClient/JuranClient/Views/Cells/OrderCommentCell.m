//
//  OrderCommentCell.m
//  JuranClient
//
//  Created by HuangKai on 15/2/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "OrderCommentCell.h"
#import "CommentStarView.h"
#import "JRDesignCreditDto.h"

@interface OrderCommentCell()

@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet CommentStarView *capacityPointView;
@property (nonatomic, strong) IBOutlet CommentStarView *servicePointView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *tIdLabel;

@end

@implementation OrderCommentCell

- (void)awakeFromNib {
    // Initialization code
    [_capacityPointView setEnable:NO];
    [_servicePointView setEnable:NO];
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetHeight(_avtarImageView.frame)/2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithDesigneCreditDto:(JRDesignCreditDto *)dto{
//    [_avtarImageView setImageWithURLString:@""];
    _nameLabel.text = dto.consumerNickname;
    _timeLabel.text = dto.gmtCreate;
    _capacityPointView.selectedIndex = dto.capacityPoint;
    _servicePointView.selectedIndex = dto.servicePoint;
    _contentLabel.text = dto.content;
    _tIdLabel.text = [NSString stringWithFormat:@"设计合同订单号：%@", dto.tid];
    [_avtarImageView setImageWithURLString:dto.customerHeadUrl];
    
    CGRect frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(_contentLabel.frame)];
    _contentLabel.frame = frame;
    
    frame = _tIdLabel.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _tIdLabel.frame = frame;
}

@end

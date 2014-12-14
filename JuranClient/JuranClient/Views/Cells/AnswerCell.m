//
//  AnswerCell.m
//  JuranClient
//
//  Created by song.he on 14-12-11.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AnswerCell.h"
#import "JRAnswer.h"

@interface AnswerCell()
{
    
}
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *userTypeLabel;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIView *footerView;

@property (nonatomic, assign) BOOL isAdoptedAnswer;

@end

@implementation AnswerCell

- (void)awakeFromNib {
    // Initialization code
    _userTypeLabel.layer.masksToBounds = YES;
    _userTypeLabel.layer.cornerRadius = _userTypeLabel.frame.size.height/2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithAnswer:(JRAnswer*)answer anIsAdoptedAnswer:(BOOL)flag
{
    _isAdoptedAnswer = flag;
    _contentLabel.text = answer.content;
    _userNameLabel.text = answer.nickName.length?answer.nickName:answer.account;
    _userTypeLabel.text = [answer userTypeString];
    _timeLabel.text = answer.commitTime;
    [self layoutFrame];
}

- (void)layoutFrame{
    CGRect frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(_contentLabel.frame)];
    _contentLabel.frame = frame;
    
    frame = _footerView.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _footerView.frame = frame;
    
    frame = _userNameLabel.frame;
    frame.size.width = [_userNameLabel.text widthWithFont:_userNameLabel.font constrainedToHeight:CGRectGetHeight(_userNameLabel.frame)];
    _userNameLabel.frame = frame;
    
    _userTypeLabel.hidden = !_isAdoptedAnswer;
    frame = _userTypeLabel.frame;
    frame.origin.x = CGRectGetMaxX(_userNameLabel.frame) + 10;
    _userTypeLabel.frame = frame;
    
    frame = _backView.frame;
    frame.size.height = CGRectGetMaxY(_footerView.frame);
    _backView.frame = frame;
    
    frame = self.contentView.frame;
    frame.size.height = CGRectGetHeight(_backView.frame) + 1;
    self.contentView.frame = frame;
    
    
}

@end

//
//  PushMessageCell.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PushMessageCell.h"
#import "JRPushInfoMsg.h"

@interface PushMessageCell()

@property (nonatomic, strong) JRPushInfoMsg *pushInfoMsg;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *redPointView;
@property (nonatomic, strong) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) IBOutlet UIButton *detailButton;

@end

@implementation PushMessageCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:tap];
    
    _redPointView.layer.masksToBounds = YES;
    _redPointView.layer.cornerRadius = _redPointView.frame.size.height/2;
    _redPointView.hidden = NO;
    
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 3.f;
    _detailButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)fillCellWithMsg:(JRPushInfoMsg*)msg{
    _pushInfoMsg = msg;
    _redPointView.hidden = !msg.isUnread;
    _titleLabel.text = msg.msgTitle;
    _timeLabel.text = msg.gmtCreate;
    _contentLabel.text = msg.msgAbstract;
    _arrowImageView.image = [UIImage imageNamed:msg.isExpand?@"arrow_up.png":@"arrow_down.png"];
    [self adjustFrame];
}

- (void)handleTap:(UIGestureRecognizer*)gesture{
    _pushInfoMsg.isExpand = !_pushInfoMsg.isExpand;
    if ([_delegate respondsToSelector:@selector(changeCellExpand:)]) {
        [_delegate changeCellExpand:self];
    }
}

- (IBAction)onDetail:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedDetail:andPushMsg:)]) {
        [_delegate didSelectedDetail:self andPushMsg:_pushInfoMsg];
    }
}

- (void)adjustFrame{
    CGRect frame = _titleLabel.frame;
    frame.size.height = [_titleLabel.text heightWithFont:_titleLabel.font constrainedToWidth:_titleLabel.frame.size.width];
    _titleLabel.frame = frame;
    
    frame = _timeLabel.frame;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame)+5;
    _timeLabel.frame = frame;
    
    _contentLabel.numberOfLines = 0;
    frame = _contentLabel.frame;
    frame.origin.y = CGRectGetMaxY(_timeLabel.frame) + 5;
    
    CGFloat height =[_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:_contentLabel.frame.size.width];
    
    if (!_pushInfoMsg.isExpand) {
        if (height > 35) {
            _contentLabel.numberOfLines = 2;
            frame.size.height = 35;
        }else{
            frame.size.height = height;
        }
    }else{
        frame.size.height = height;
    }
    
    if (_contentLabel.text.length == 0) {
        frame.size.height = 0;
    }
    _contentLabel.frame = frame;
    
   height = CGRectGetMaxY(_contentLabel.frame) + 10;
    if (_pushInfoMsg.isExpand) {
        _detailButton.hidden = NO;
        
        frame = _detailButton.frame;
        frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
        _detailButton.frame = frame;
        
        height =  CGRectGetMaxY(_detailButton.frame) + 10;
    }else{
        _detailButton.hidden = YES;
    }
    
    frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    frame = self.contentView.frame;
    frame.size.height = CGRectGetHeight(self.frame);
    self.contentView.frame = frame;
    
    if (_pushInfoMsg.isUnread) {
        self.backgroundColor = RGBColor(240, 240, 240);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

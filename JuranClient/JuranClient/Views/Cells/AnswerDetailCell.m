//
//  AnswerDetailCell.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AnswerDetailCell.h"
#import "ZoomInImageView.h"

@interface AnswerDetailCell()
{
    
}
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet ZoomInImageView *contentImageView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *acceptButton;
@property (nonatomic, strong) IBOutlet UIView *bgView;

@property (nonatomic, strong) JRAnswer *answer;
@property (nonatomic, assign) NSInteger type;
//0 表示待解决的我的提问
//1 表示已解决的我的提问
//2 表示答疑解惑中的提问


@end

@implementation AnswerDetailCell

- (void)awakeFromNib {
    // Initialization code
    _flagImageView.hidden = YES;
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2.f;
    
    _acceptButton.hidden = YES;
//    _acceptButton.layer.masksToBounds = YES;
//    _acceptButton.layer.cornerRadius = 3;
//    _acceptButton.layer.borderWidth = 1;
//    _acceptButton.layer.borderColor = RGBColor(214, 220, 233).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithAnswer:(JRAnswer*) answer type:(NSInteger)type
{
    _type = type;
    _answer = answer;
    _nameLabel.text = _answer.nickName.length?_answer.nickName:_answer.account;
    if (_answer.headUrl.length > 0) {
        [_headImageView setImageWithURLString:_answer.headUrl];
    }else{
        [_headImageView setImage:[UIImage imageNamed:@"unlogin_head.png"]];
    }
    _timeLabel.text = _answer.commitTime;
    _contentLabel.text = _answer.content;
    if (answer.imageUrl.length > 0) {
        [_contentImageView setImageWithURLString:answer.imageUrl];
    }
    [self adjustFrame];
}


- (void)adjustFrame{
    CGRect frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:_contentLabel.frame.size.width];
    _contentLabel.frame = frame;
    
    if (_answer.imageUrl && _answer.imageUrl.length > 0) {
        _contentImageView.hidden = NO;
        frame = _contentImageView.frame;
        frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
        _contentImageView.frame = frame;
        
        _acceptButton.hidden = YES;
        frame = _acceptButton.frame;
        frame.origin.y = CGRectGetMaxY(_contentImageView.frame) - CGRectGetHeight(_acceptButton.frame);
        _acceptButton.frame = frame;
    }else{
        _contentImageView.hidden = YES;
        _acceptButton.hidden = YES;
        frame = _acceptButton.frame;
        frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
        _acceptButton.frame = frame;
    }

    frame = _bgView.frame;
    if (_type == 0) {
        _acceptButton.hidden = NO;
        frame.size.height = CGRectGetMaxY(_acceptButton.frame) + 10;
    }else{
        if (_answer.imageUrl && _answer.imageUrl.length > 0){
            frame.size.height = CGRectGetMaxY(_contentImageView.frame) + 10;
        }else{
            frame.size.height = CGRectGetMaxY(_contentLabel.frame) + 10;
        }
        if(_type == 1){
            _flagImageView.hidden = !_answer.bestAnswerFlag;
            _bgView.backgroundColor = _answer.bestAnswerFlag?RGBColor(237, 253, 246):[UIColor whiteColor];
            
        }
    }
    _bgView.frame = frame;
    
    frame = self.contentView.frame;
    frame.size.height = CGRectGetMaxY(_bgView.frame) + 1;
    self.contentView.frame = frame;
}

- (IBAction)adoptAnswer:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(answerDetailCell:adoptAnswer:)]) {
        [_delegate answerDetailCell:self adoptAnswer:_answer];
    }
}

@end

//
//  PrivateMessageCell.m
//  JuranClient
//
//  Created by Kowloon on 14/12/10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PrivateMessageCell.h"
#import "PrivateMessage.h"

@interface PrivateMessageCell ()

@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *numButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@end

@implementation PrivateMessageCell

- (void)awakeFromNib {
    // Initialization code
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame)/2;
    
    _numButton.layer.masksToBounds = YES;
    _numButton.layer.cornerRadius = CGRectGetWidth(_numButton.frame)/2;
    _numButton.hidden = YES;
}

- (void)fillCellWithData:(PrivateMessage *)message{
    if (message.unReadNum == 0) {
        _numButton.hidden = YES;
    }else{
        _numButton.hidden = NO;
        [_numButton setTitle:[NSString stringWithFormat:@"%d", message.unReadNum] forState:UIControlStateNormal];
    }
    [_avtarImageView setImageWithURLString:message.senderHeadUrl];
    _nameLabel.text = message.senderNickName;
    _contentLabel.text = message.content;
    _timeLabel.text = message.publishCustomTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

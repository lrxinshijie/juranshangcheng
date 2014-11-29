//
//  CommentCell.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CommentCell.h"
#import "JRComment.h"

@interface CommentCell ()

@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIButton *typeButton;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

- (IBAction)onComment:(id)sender;

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithComment:(JRComment *)data{
    [_avtarImageView setImageWithURL:[Public imageURL:data.headUrl]];
    _nameLabel.text = data.nickName;
    _timeLabel.text = data.commentTime;
    NSString *content = data.commentContent;
    _contentLabel.text = content;
    
    CGRect frame = _contentLabel.frame;
    frame.size.height = [content heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(frame)];
    _contentLabel.frame = frame;
    
    frame = _mainView.frame;
    frame.size.height = CGRectGetMaxY(_contentLabel.frame) + 10;
    _mainView.frame = frame;
}

- (IBAction)onComment:(id)sender{
}

@end

//
//  CommentCell.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CommentCell.h"
#import "JRComment.h"
#import "ReplyView.h"

@interface CommentCell ()

@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIButton *typeButton;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) ReplyView *replyView;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IBOutlet UIView *contentImageView;

- (IBAction)onComment:(id)sender;
- (IBAction)onReply:(id)sender;

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
    
    _typeButton.layer.masksToBounds = YES;
    _typeButton.layer.cornerRadius = 5;
    
    self.replyView = [[ReplyView alloc] initWithFrame:CGRectMake(10, 0, 290, 0)];
    [_mainView addSubview:_replyView];
    
    _contentImageView.hidden = YES;
}

- (IBAction)onReply:(id)sender{
    _comment.unfold = !_comment.unfold;
    if ([_delegate respondsToSelector:@selector(clickCellUnfold:)]) {
        [_delegate clickCellUnfold:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithComment:(JRComment *)data{
    self.comment = data;
    
    _replyView.replys = _comment.replyList;
    
    [_avtarImageView setImageWithURLString:data.headUrl];
    NSString *nickName = data.nickName;
    _nameLabel.text = nickName;
    
    _typeButton.hidden = YES;
    if ([[data.userType lowercaseString] isEqualToString:@"designer"] || data.userType.integerValue == 2) {
        _typeButton.hidden = NO;
        CGRect frame = _typeButton.frame;
        frame.origin.x = CGRectGetMinX(_nameLabel.frame) + [nickName widthWithFont:_nameLabel.font constrainedToHeight:CGRectGetHeight(_nameLabel.frame)] + 5;
        _typeButton.frame = frame;
    }
    _timeLabel.text = data.commentTime;
    NSString *content = data.commentContent;
    _contentLabel.text = content;
    
    CGRect frame = _contentLabel.frame;
    frame.size.height = [content heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(frame)];
    _contentLabel.frame = frame;
    
    CGFloat replyViewY = 0;
    
    if (data.imageUrlList.count > 0) {
        _contentImageView.hidden = NO;
        NSInteger i = 0;
        for (NSString *name in data.imageUrlList) {
            UIImageView *imgView = (UIImageView*)[_contentImageView viewWithTag:2300 + i];
            imgView.hidden = NO;
            imgView.image = [UIImage imageNamed:@"image_default.png"];
            [imgView setImageWithURLString:name];
            i++;
        }
        
        for (; i < 3; i ++) {
            UIImageView *imgView = (UIImageView*)[_contentImageView viewWithTag:2300 + i];
            imgView.hidden = YES;
            imgView.image = nil;
        }
        
        frame = _contentImageView.frame;
        frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
        _contentImageView.frame = frame;
        
        replyViewY = CGRectGetMaxY(_contentImageView.frame);
    }else{
        _contentImageView.hidden = YES;
        replyViewY = CGRectGetMaxY(_contentLabel.frame);
    }
    
    frame = _replyView.frame;
    frame.origin.y = replyViewY + 5;
    _replyView.frame = frame;
    
    frame.size.height = _comment.unfold ? _replyView.height : 0;
    _replyView.frame = frame;
    
    [_replyButton setTitle:_comment.unfold ? @"收起回复" : @"展开回复" forState:UIControlStateNormal];
    
    _replyButton.hidden = _comment.replyList.count == 0;
    _replyView.hidden = !_comment.unfold;
    
    frame = _replyButton.frame;
    frame.origin.y = CGRectGetMaxY(_replyView.frame) + 5;
    _replyButton.frame = frame;
    
    frame = _mainView.frame;
    frame.size.height = (_comment.replyList.count == 0 ? CGRectGetMaxY(_replyView.frame) :  CGRectGetMaxY(_replyButton.frame)) + 10;
    _mainView.frame = frame;
    
    
}

- (IBAction)onComment:(id)sender{
    if ([_delegate respondsToSelector:@selector(clickCellComment:)]) {
        [_delegate clickCellComment:self];
    }
}

@end

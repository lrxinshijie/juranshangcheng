//
//  AskOrAnswerCell.m
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AskOrAnswerCell.h"
#import "JRAnswer.h"
#import "JRQuestion.h"

@interface AskOrAnswerCell()

@property (nonatomic, weak) IBOutlet UIView *tempView;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIView *redPointView;

@end

@implementation AskOrAnswerCell

- (void)awakeFromNib
{
    // Initialization code
    _redPointView.layer.masksToBounds = YES;
    _redPointView.layer.cornerRadius = _redPointView.frame.size.height/2;
    _redPointView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithAnswer:(JRAnswer *)data{
    _contentLabel.text = data.title;
    _statusLabel.text = @"已解决";
    _timeLabel.text = @"回答：5  |  2014-9-20";
    [self adjustFrame];
}
- (void)fillCellWithQuestion:(JRQuestion *)data{
    _contentLabel.text = data.title;
    _statusLabel.text = @"已解决";
    _timeLabel.text = @"回答：5  |  2014-9-20";
    [self adjustFrame];
}

- (void)adjustFrame{
    CGRect frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:_contentLabel.frame.size.width];
    _contentLabel.frame = frame;
    
    frame = _tempView.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _tempView.frame = frame;
    
    frame = _backView.frame;
    frame.size.height = CGRectGetMaxY(_tempView.frame);
    _backView.frame = frame;
}

@end

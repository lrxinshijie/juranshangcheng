//
//  AnswerDetailCell.m
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "AnswerDetailCell.h"

@interface AnswerDetailCell()
{
    //0是我的回答， 1是我的提问
    NSInteger type;
}
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *acceptButton;

@end

@implementation AnswerDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithAnswer:(JRAnswer*) answer
{
    [self adjustFrame];
}

- (void)adjustFrame{
    CGRect frame = _contentLabel.frame;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:_contentLabel.frame.size.width];
    _contentLabel.frame = frame;
    
    _acceptButton.hidden = !type;
    
}


@end

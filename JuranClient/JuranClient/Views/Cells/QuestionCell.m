//
//  QuestionCell.m
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "QuestionCell.h"
#import "JRQuestion.h"

@interface QuestionCell()

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* describeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIView *tempView;

@end

@implementation QuestionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithQuestion:(JRQuestion *)data{
    _titleLabel.text = data.title;
    _statusLabel.text = [data isResolved]?@"已解决":@"未解决";
    _statusImageView.image = [UIImage imageNamed:data.isResolved?@"question_resolved.png":@"question_wati_resolve.png"];
    _timeLabel.text = [NSString stringWithFormat:@"回答：%d  |  %@", data.answerCount, data.publishTime];
    _describeLabel.text = [data descriptionForCell];
    _iconImageView.hidden = !(data.imageUrl.length > 0);
    [self adjustFrame];
}


- (void)adjustFrame{
    CGRect frame = _titleLabel.frame;
    frame.size.height = [_titleLabel.text heightWithFont:_titleLabel.font constrainedToWidth:_titleLabel.frame.size.width];
    _titleLabel.frame = frame;
    
    frame = _describeLabel.frame;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + 5;
    _describeLabel.frame = frame;
    
    frame = _tempView.frame;
    frame.origin.y = CGRectGetMaxY(_describeLabel.frame) + 5;
    _tempView.frame = frame;
    
    frame = _backView.frame;
    frame.size.height = CGRectGetMaxY(_tempView.frame);
    _backView.frame = frame;
    
    frame = self.contentView.frame;
    frame.size.height = CGRectGetHeight(_backView.frame) + 5;
    self.contentView.frame = frame;
}


@end

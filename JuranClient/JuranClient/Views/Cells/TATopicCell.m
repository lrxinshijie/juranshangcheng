//
//  TATopicCell.m
//  JuranClient
//
//  Created by song.he on 14-11-24.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "TATopicCell.h"
#import "JRTopic.h"

@implementation TATopicCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithTopic:(JRTopic *)data
{
    _topicContentLabel.text = [NSString stringWithFormat: @"\"%@\"", data.title];
    _ideaContentLabel.text = data.content;
    _timeLabel.text = data.commentDate;
    if (data.commentImageUrlList.count > 0) {
        [_relateImageView setImageWithURLString:data.commentImageUrlList[0]];
    }
    [self changeFrame];
}

- (void)changeFrame{
    CGRect frame = _topicContentLabel.frame;
    frame.size.height = [_topicContentLabel.text heightWithFont:_topicContentLabel.font constrainedToWidth:_topicContentLabel.frame.size.width];
    _topicContentLabel.frame = frame;
    
    frame = _ideaLabel.frame;
    frame.origin.y = CGRectGetMaxY(_topicContentLabel.frame)+5;
    _ideaLabel.frame = frame;
    
    frame = _ideaContentLabel.frame;
    frame.origin.y = _ideaLabel.frame.origin.y;
    frame.size.height = [_ideaContentLabel.text heightWithFont:_ideaContentLabel.font constrainedToWidth:_ideaContentLabel.frame.size.width];
    _ideaContentLabel.frame = frame;
    
    if (_relateImageView.image) {
        _relateImageView.hidden = NO;
        frame = _relateImageView.frame;
        frame.origin.y = CGRectGetMaxY(_ideaContentLabel.frame)+10;
        _relateImageView.frame = frame;
        
        frame = _timeLabel.frame;
        frame.origin.y = CGRectGetMaxY(_relateImageView.frame)+5;
        _timeLabel.frame = frame;
    }else{
        _relateImageView.hidden = YES;
        frame = _timeLabel.frame;
        frame.origin.y = CGRectGetMaxY(_ideaContentLabel.frame)+5;
        _timeLabel.frame = frame;
    }
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_timeLabel.frame) + 10;
    self.frame = frame;
    
    self.contentView.frame = frame;
    
    frame = self.backView.frame;
    frame.size.height = CGRectGetMaxY(self.frame) - 5;
    self.backView.frame = frame;
}



//-(void)layoutSubviews{
//    [self changeFrame];
//}

@end

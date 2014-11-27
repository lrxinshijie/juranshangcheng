//
//  TATopicCell.m
//  JuranClient
//
//  Created by song.he on 14-11-24.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "TATopicCell.h"

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

- (void)setDatas:(id)sender
{
    _topicContentLabel.text = @"\"平房座北潮南的说法的\"";
    _ideaContentLabel.text = @"别说是加夫里是雷锋精神了对方极乐世界的法律理发师江东父老手机发了科技实力的什江东父老就是来得及发了快睡觉了；老师的飞机上了";
    _timeLabel.text = @"2014-10-23";
    [self changeFrame];
}

- (void)changeFrame{
    CGRect frame = _topicContentLabel.frame;
    frame.size = [self sizeWithText:_topicContentLabel.text font:_topicContentLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(_topicContentLabel.frame), MAXFLOAT)];
    _topicContentLabel.frame = frame;
    
    frame = _ideaLabel.frame;
    frame.origin.y = CGRectGetMaxY(_topicContentLabel.frame)+5;
    _ideaLabel.frame = frame;
    
    frame = _ideaContentLabel.frame;
    frame.origin.y = _ideaLabel.frame.origin.y;
    frame.size = [self sizeWithText:_ideaContentLabel.text font:_ideaContentLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(_ideaContentLabel.frame), MAXFLOAT)];
    _ideaContentLabel.frame = frame;
    
    frame = _timeLabel.frame;
    frame.origin.y = CGRectGetMaxY(_ideaContentLabel.frame)+5;
    _timeLabel.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_timeLabel.frame) + 10;
    self.frame = frame;
    
    self.contentView.frame = frame;
    
    frame = self.backView.frame;
    frame.size.height = CGRectGetMaxY(self.frame) - 5;
    self.backView.frame = frame;
}

- (CGSize)sizeWithText:(NSString*)text font:(UIFont*)font constrainedToSize:(CGSize)sz{
    CGSize size;
    if (SystemVersionGreaterThanOrEqualTo7) {
        size = [text sizeWithFont:font constrainedToSize:sz lineBreakMode:NSLineBreakByCharWrapping];
    }else{
        NSDictionary *attribute = @{NSFontAttributeName: font};
        size = [text boundingRectWithSize:sz options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    return size;
}

//- (void)layoutSubviews{
//    [self changeFrame];
//    [super layoutSubviews];
//    
//}

@end

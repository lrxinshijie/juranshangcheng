//
//  ActivityCell.m
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ActivityCell.h"
#import "JRActivity.h"

@interface ActivityCell()

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *buttonView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *contentImageView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) JRActivity *activity;

@end


@implementation ActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithActivity:(JRActivity*)activity{
    _activity = activity;
    
    _nameLabel.text = activity.activityName;
    _contentLabel.text = activity.activityIntro;
    [_contentImageView setImageWithURLString:activity.activityListUrl];
    [self adjustFrame];
}

- (void)adjustFrame{
    CGRect frame = _contentLabel.frame;
    if (_activity.activityListUrl.length == 0) {
        _contentImageView.hidden = YES;
        frame.origin.y = CGRectGetMaxY(_nameLabel.frame) + 5;
    }else{
        _contentImageView.hidden = NO;
        frame.origin.y = CGRectGetMaxY(_contentImageView.frame) + 5;
    }
    
    CGFloat height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(_contentLabel.frame)];
    if (height > 55) {
        height = 55;
    }
    frame.size.height = height;
    _contentLabel.frame = frame;
    
    frame = _buttonView.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _buttonView.frame = frame;
    
    frame = _bgView.frame;
    frame.size.height = CGRectGetMaxY(_buttonView.frame);
    _bgView.frame = frame;
    
    frame = self.contentView.frame;
    frame.size.height = CGRectGetMaxY(_bgView.frame);
    self.contentView.frame = frame;
}

@end

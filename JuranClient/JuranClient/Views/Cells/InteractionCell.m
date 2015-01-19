//
//  InteractionCell.m
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "InteractionCell.h"

@interface InteractionCell()

@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *redPointView;
@property (nonatomic, strong) IBOutlet UIImageView *headImgeView;

@end

@implementation InteractionCell

- (void)awakeFromNib
{
    // Initialization code
    _headImgeView.layer.masksToBounds = YES;
    _headImgeView.layer.cornerRadius = _headImgeView.frame.size.height/2;
    _headImgeView.hidden = NO;
    
//    _redPointView.layer.masksToBounds = YES;
//    _redPointView.layer.cornerRadius = _redPointView.frame.size.height/2;
//    _redPointView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithInteraction:(NSDictionary *)dict{
    
    NSString *topicTitle = [dict getStringValueForKey:@"topicTitle" defaultValue:@""];
    NSString *projectTitle = [dict getStringValueForKey:@"projectTitle" defaultValue:@""];
    NSString *commentContent = [dict getStringValueForKey:@"commentContent" defaultValue:@""];
    NSString *commentTime = [dict getStringValueForKey:@"commentTime" defaultValue:@""];
    NSString *nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
    NSString *account = [dict getStringValueForKey:@"account" defaultValue:@""];
    NSString *headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
    
    _userNameLabel.text = nickName.length == 0 ? account : nickName;
    _timeLabel.text = commentTime;
    [_headImgeView setImageWithURLString:headUrl];
    _contentLabel.text = [NSString stringWithFormat:@"评论:%@", commentContent];
    
    if (projectTitle.length == 0) {
        _titleLabel.text = [NSString stringWithFormat:@"原话题:%@", topicTitle];
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"原案例:%@", projectTitle];
    }
    
    
    
}

@end

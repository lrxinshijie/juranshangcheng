//
//  CaseCell.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CaseCell.h"
#import "JRCase.h"

@interface CaseCell ()

@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;
@property (nonatomic, strong) IBOutlet UILabel *avtarLabel;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *browseButton;

@end

@implementation CaseCell

- (void)awakeFromNib
{
    // Initialization code
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _avtarImageView.layer.borderWidth = 2;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithCase:(JRCase *)data{
    [_photoImageView setImageWithURL:[data imageURL]];
    _titleLabel.text = data.title;
    _avtarLabel.text = data.nickName;
    [_likeButton setTitle:[NSString stringWithFormat:@" %d", data.likeCount] forState:UIControlStateNormal];
    [_browseButton setTitle:[NSString stringWithFormat:@" %d", data.viewCount] forState:UIControlStateNormal];
}

@end

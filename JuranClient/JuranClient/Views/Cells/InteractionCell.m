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
    
    _redPointView.layer.masksToBounds = YES;
    _redPointView.layer.cornerRadius = _redPointView.frame.size.height/2;
    _redPointView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithInteraction:(NSString*)data{
    
}

@end

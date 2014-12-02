//
//  DemandCell.m
//  JuranClient
//
//  Created by song.he on 14-12-1.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DemandCell.h"

@implementation DemandCell

- (void)awakeFromNib
{
    // Initialization code
    _bidNumberView.layer.masksToBounds = YES;
    _bidNumberView.layer.cornerRadius = _bidNumberView.frame.size.height/2;
    _bidNumberView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

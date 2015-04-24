//
//  CategaryTableViewCell.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CategaryTableViewCell.h"

@interface CategaryTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *line;


@end

@implementation CategaryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)configCellUIWithItem:(CategaryTableViewCellItem *)item
{
    self.titleLabel.text = item.name;
    self.cell_id = item.code;
}

- (void)setCellTitleSelect
{
    self.titleLabel.textColor = [UIColor colorWithRed:11.0/255.0 green:75.0/255.0 blue:152.0/255.0 alpha:1.0];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.line.hidden = YES;
}

- (void)setCellTitleNormal
{
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0]];
    self.line.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

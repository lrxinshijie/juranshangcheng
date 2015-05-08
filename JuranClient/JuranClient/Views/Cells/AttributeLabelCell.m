//
//  AttributeLabelCell.m
//  JuranClient
//
//  Created by 李 久龙 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "AttributeLabelCell.h"

@interface AttributeLabelCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation AttributeLabelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillCellWithData:(NSString *)title{
    _titleLabel.text = title;
    _titleLabel.backgroundColor = [UIColor redColor];
    
    CGRect frame = _titleLabel.frame;
    frame.size = [AttributeLabelCell cellSizeWithTitle:title];
    _titleLabel.frame = frame;
    
    _titleLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    _titleLabel.layer.borderWidth = 1;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.cornerRadius = 3;
}

+ (CGSize)cellSizeWithTitle:(NSString *)title{
    CGSize size = CGSizeMake(0, 25);
    size.width = [title widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:size.height] + 10;
    return size;
}

@end

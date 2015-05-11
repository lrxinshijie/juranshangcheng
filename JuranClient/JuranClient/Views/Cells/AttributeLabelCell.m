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
@property (nonatomic, copy) NSString *title;

@end

@implementation AttributeLabelCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
//    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.autoresizesSubviews = YES;
//    _titleLabel.clipsToBounds = YES;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)fillCellWithData:(NSString *)title{
    self.title = title;
    
    _titleLabel.text = title;
    
    CGRect frame = _titleLabel.frame;
    frame.size = [AttributeLabelCell cellSizeWithTitle:_title];
    _titleLabel.frame = frame;
//    _titleLabel.frame = self.bounds;
    
    _titleLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    _titleLabel.layer.borderWidth = 1;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.cornerRadius = 3;
    
//    [self layoutSubviews];
//    [self viewDidLayoutSubviews];
}

+ (CGSize)cellSizeWithTitle:(NSString *)title{
    CGSize size = CGSizeMake(0, 25);
    size.width = [title widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:size.height] + 10;
    return size;
}

@end

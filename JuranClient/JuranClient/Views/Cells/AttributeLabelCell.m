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
}

@end

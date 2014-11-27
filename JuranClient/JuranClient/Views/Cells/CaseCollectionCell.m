//
//  CaseCollectionCell.m
//  JuranClient
//
//  Created by Kowloon on 14/11/25.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "CaseCollectionCell.h"

@interface CaseCollectionCell ()

@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avtarImageView;

@end

@implementation CaseCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    _avtarImageView.layer.masksToBounds = YES;
    _avtarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _avtarImageView.layer.borderWidth = 1;
    _avtarImageView.layer.cornerRadius = CGRectGetWidth(_avtarImageView.frame) / 2;
}

- (void)fillCellWithCase:(JRCase *)data{
}

@end

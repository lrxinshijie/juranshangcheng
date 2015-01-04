//
//  CaseImageHeaderView.m
//  JuranClient
//
//  Created by HuangKai on 15/1/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseImageHeaderView.h"

@interface CaseImageHeaderView()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *lineView;

@end

@implementation CaseImageHeaderView

- (void)setTitle:(NSString*)title lineHidden:(BOOL)hidden{
    _titleLabel.text = title;
    _lineView.hidden = hidden;
}

- (void)awakeFromNib {
    // Initialization code
}

@end

//
//  CaseManagementCell.m
//  JuranClient
//
//  Created by HuangKai on 15/1/2.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CaseManagementCell.h"
#import "JRCase.h"

@interface CaseManagementCell()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *frontImageView;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *reasonLabel;
@property (nonatomic, strong) IBOutlet UIView *reasonView;


@end

@implementation CaseManagementCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithValue:(id)data{
    JRCase *jc = (JRCase*)data;
    _titleLabel.text = jc.title;
    _timeLabel.text = jc.publishTime;
    _statusLabel.text = [jc statusString];
    _statusLabel.textColor = [jc statusColor];
    
    NSString *content = [NSString stringWithFormat:@"原因：%@", jc.reason];
    if ([jc.status isEqualToString:@"02"] && jc.reason.length > 0) {
        _reasonLabel.hidden = NO;
        CGRect frame = _reasonLabel.frame;
        frame.size.height = [content heightWithFont:_reasonLabel.font constrainedToWidth:CGRectGetWidth(frame)];
        _reasonLabel.frame = frame;
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.text = content;
        
        frame = _reasonView.frame;
        frame.size.height = CGRectGetHeight(_reasonLabel.frame) + 10;
        _reasonView.frame = frame;
    }else{
        _reasonView.hidden = YES;
    }
    [_frontImageView setImageWithURLString:jc.frontImgUrl];
}

@end

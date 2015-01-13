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
    
    NSString *content = jc.reason;
    if ([jc.status isEqualToString:@"02"] && content.length > 0) {
        _reasonLabel.hidden = NO;
        CGRect frame = _reasonLabel.frame;
        frame.size.height = [content heightWithFont:_reasonLabel.font constrainedToWidth:CGRectGetWidth(frame)]+5;
        _reasonLabel.frame = frame;
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.text = content;
    }else{
        _reasonLabel.hidden = YES;
    }
    [_frontImageView setImageWithURLString:jc.frontImgUrl];
}

@end

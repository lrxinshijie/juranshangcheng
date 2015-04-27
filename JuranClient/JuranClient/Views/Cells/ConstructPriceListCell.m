//
//  ConstructPriceListCell.m
//  JuranClient
//
//  Created by HuangKai on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ConstructPriceListCell.h"

@interface ConstructPriceListCell()

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *infoView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalPriceLabel;

@end

@implementation ConstructPriceListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithValue:(id)value isHead:(BOOL)flag{
    [_headerView removeFromSuperview];
    [_infoView removeFromSuperview];
    if (flag) {
        [self addSubview:_headerView];
    }else{
        _nameLabel.text = @"洛杉矶的弗兰克是理科的法律";
        _numberLabel.text = @"1";
        _unitPriceLabel.text = @"￥73.00/平米";
        _totalPriceLabel.text = @"￥73.00";
        
        CGRect frame = _nameLabel.frame;
        frame.size.height = [_nameLabel.text heightWithFont:_nameLabel.font constrainedToWidth:CGRectGetWidth(_nameLabel.frame)];
        _nameLabel.frame = frame;
        
        _numberLabel.center = CGPointMake(_numberLabel.center.x, _nameLabel.center.y);
        _unitPriceLabel.center = CGPointMake(_unitPriceLabel.center.x, _nameLabel.center.y);
        _totalPriceLabel.center = CGPointMake(_totalPriceLabel.center.x, _nameLabel.center.y);
        [self addSubview:_infoView];
    }
}

+ (CGFloat)cellHeightWithValue:(id)value isHead:(BOOL)flag{
    if (flag) {
        return 33;
    }else{
        NSString *s = @"洛杉矶的弗兰克是理科的法律";
        CGFloat height = [s heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:96];
        return height+6;
    }
}

@end

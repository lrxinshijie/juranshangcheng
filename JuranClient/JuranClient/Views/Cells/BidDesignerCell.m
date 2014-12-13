//
//  BidDesignerCell.m
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "BidDesignerCell.h"
#import "JRDesigner.h"

@interface BidDesignerCell()

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *styleLabel;
@property (nonatomic, strong) IBOutlet UILabel *experienceLabel;
@property (nonatomic, strong) IBOutlet UILabel *produntCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *browseCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *declarationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headImageView;

@end

@implementation BidDesignerCell

- (void)awakeFromNib {
    // Initialization code
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithDesigner:(JRDesigner*)designer{
    _nameLabel.text = designer.nickName.length?designer.nickName:designer.account;
    if (designer.headUrl.length > 0) {
        [_headImageView setImageWithURLString:designer.headUrl];
    }else{
        _headImageView.image = [UIImage imageNamed:@"unlogin_head.png"];
    }
    
    _styleLabel.text = [designer styleNamesWithType:0];
    _experienceLabel.text =  [NSString stringWithFormat:@"%d年", designer.experienceCount];
    _produntCountLabel.text = [NSString stringWithFormat:@"%i", designer.projectCount];
    _browseCountLabel.text = [NSString stringWithFormat:@"%i", designer.browseCount];
//    _declarationLabel.text = 
}

@end

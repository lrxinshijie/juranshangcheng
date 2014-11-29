//
//  DesignerCell.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DesignerCell.h"
#import "JRDesigner.h"
#import "JRDesignerFollowDto.h"
#import "JRCase.h"

#define kCaseImageViewTag 1010

@implementation DesignerCell

- (void)awakeFromNib
{
    // Initialization code
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2.f;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2, 5, self.frame.size.width - 4, self.frame.size.height - 5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView insertSubview:view atIndex:0];
    
    CGRect frame = _sContentView.frame;
    frame.origin.y += 5;
    _sContentView.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithDesigner:(JRDesigner *)data{
    _nameLabel.text = data.nickName;
    _styleLabel.text = [data styleNamesWithType:0];
    _experienceLabel.text =  @"2年";
    _productCountLabel.text = [NSString stringWithFormat:@"%i", data.projectCount];
    _readCountLabel.text = [NSString stringWithFormat:@"%i", data.projectCount];
    NSInteger i = 0;
    for (JRCase *c in data.projectDtoList) {
        UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:i + kCaseImageViewTag];
        imageView.image = [UIImage imageNamed:@"case_pic_exa.png"]; //[imageView setImageWithURL:[c imageURL] placeholderImage:nil];
        i++;
    }
    for (; i < 4; i++) {
        UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:i + kCaseImageViewTag];
        imageView.image = [UIImage imageNamed:@"designer_no_pic.png"];
    }
}

- (void)fillCellWithDesignerFollowDto:(JRDesignerFollowDto *)data{
    _nameLabel.text = data.nickName;
//    _styleLabel.text = [data styleNamesForDesignerList];
    _experienceLabel.text = @"2年"; ;
//    [_productCountButton setTitle:[NSString stringWithFormat:@"  %i", data.projectCount] forState:UIControlStateNormal];
//    [_readCountButton setTitle:[NSString stringWithFormat:@"  %i", data.projectCount] forState:UIControlStateNormal];
    NSInteger i = 0;
    for (; i < 4; i++) {
        UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:i + kCaseImageViewTag];
        imageView.backgroundColor = [UIColor greenColor];
    }
}

@end

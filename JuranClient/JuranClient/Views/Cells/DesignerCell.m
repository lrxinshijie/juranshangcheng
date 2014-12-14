//
//  DesignerCell.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DesignerCell.h"
#import "JRDesigner.h"
#import "JRCase.h"

#define kCaseImageViewTag 1010

@implementation DesignerCell

- (void)awakeFromNib
{
    // Initialization code
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2.f;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 5)];
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

- (void)fillCellWithDesignerFollowDto:(JRDesignerFollowDto *)data{
}

- (void)fillCellWithDesigner:(JRDesigner *)data{
    _nameLabel.text = data.nickName.length?data.nickName:data.account;
    if (data.headUrl.length > 0) {
        [_headImageView setImageWithURLString:data.headUrl];
    }else{
        _headImageView.image = [UIImage imageNamed:@"unlogin_head.png"];
    }
    
    _styleLabel.text = [data styleNamesWithType:0];
    _experienceLabel.text =  [NSString stringWithFormat:@"%d年", data.experienceCount];
    _productCountLabel.text = [NSString stringWithFormat:@"%i", data.projectCount];
    _readCountLabel.text = [NSString stringWithFormat:@"%i", data.browseCount];
    NSInteger i = 0;
    for (NSString *url in data.frontImageUrlList) {
        UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:i + kCaseImageViewTag];
        [imageView setImageWithURLString:url];
        i++;
    }
    for (; i < 4; i++) {
        UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:i + kCaseImageViewTag];
        imageView.image = [UIImage imageNamed:@"designer_no_pic.png"];
    }
}

@end

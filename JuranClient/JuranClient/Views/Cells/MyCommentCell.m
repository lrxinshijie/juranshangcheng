//
//  MyCommentCell.m
//  JuranClient
//
//  Created by 123 on 15/11/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "MyCommentCell.h"
#import "ZoomInImageView.h"

@implementation MyCommentCell

- (void)awakeFromNib {
    // Initialization code
    [self.staticStarRatingView setEnable:NO];
    _contentImageView.hidden = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)btnSelectClick:(id)sender {
    
    _isSelected=!_isSelected;
    
    if(_isSelected && _delegate && [_delegate respondsToSelector:@selector(setSelectedItem:)])
    {
        
        [_btnSelect setImage:[UIImage imageNamed:@"checkbox_checked_okk"] forState:UIControlStateNormal];
        _model.isDelete=YES;
        [_delegate setSelectedItem:1];
    }
    else
    {
        [_btnSelect setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        _model.isDelete=NO;
        [_delegate setSelectedItem:-1];

    }
    
    
}

-(void)setData:(JRShopOrProduceComment *)model
{
    self.model=model;
    NSString *content = model.content;
    _labTitle.lineBreakMode = NSLineBreakByCharWrapping;
    self.labTitle.numberOfLines=0;
    self.labTitle.text = content;
    CGRect frame = self.labTitle.frame;
    
    if(_model.isDelete)
    {
        [_btnSelect setImage:[UIImage imageNamed:@"checkbox_checked_okk"] forState:UIControlStateNormal];
        _isSelected=YES;
    }
    else
    {
        [_btnSelect setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        _isSelected=NO;
    }
    
    _labName.text=model.relName;
    frame.size.height = [content heightWithFont:_labTitle.font constrainedToWidth:CGRectGetWidth(frame)];
    self.labTitle .frame = frame;
    [self.labTime setText:model.gmtCreate];
    self.labTitle.lineBreakMode= NSLineBreakByTruncatingTail;
    [self.staticStarRatingView setSelectedIndex:model.rank];
    
    
    if(model.imgList && model.imgList.count>0)
    {
        _contentImageView.hidden = NO;
        NSInteger i = 0;
        for (NSString *name in model.imgList) {
            ZoomInImageView *imgView = (ZoomInImageView*)[_contentImageView viewWithTag:2300 + i];
            imgView.hidden = NO;
            imgView.contentMode=UIViewContentModeCenter;
            imgView.clipsToBounds  = YES;
            UIImage  *image = [UIImage imageNamed:@"image_default.png"];
            [imgView setImageWithURLString:name placeholderImage:image];
//            [imgView setImageWithURLString:name];
            imgView.url=name;

            i++;
        }
        
        for (; i < 3; i ++) {
            UIImageView *imgView = (UIImageView*)[_contentImageView viewWithTag:2300 + i];
            imgView.hidden = YES;
            imgView.image = nil;
        }
        
        frame = _contentImageView.frame;
        frame.origin.y = CGRectGetMaxY(_labTitle.frame) + 5;
        _contentImageView.frame = frame;
    }
    else
    {
        _contentImageView.hidden=YES;
    }
 
    CGRect mainFrame=self.frame;
    mainFrame.size.height=(model.imgList.count==0?CGRectGetMaxY(_labTitle.frame):CGRectGetMaxY(_contentImageView.frame))+10;
    self.frame=mainFrame;
}



@end

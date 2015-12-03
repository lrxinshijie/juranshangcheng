//
//  CommentListCell.m
//  JuranClient
//
//  Created by 123 on 15/11/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CommentListCell.h"
#import "SDWebImageManager.h"
#import "TTTAttributedLabel.h"
#import "AddReplyViewController.h"
#import "ZoomInImageView.h"

@implementation CommentListCell


- (void)awakeFromNib {
    // Initialization code
    [_staticStarRatingView setEnable:NO];
    _contentImageView.hidden=YES;
    _imageHeader.layer.masksToBounds = YES;
    _imageHeader.layer.cornerRadius = _imageHeader.frame.size.width / 2.f;
    _imageHeader.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageHeader.layer.borderWidth = 1.f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setData:(JRShopOrProduceComment *)model
{
    self.model=model;
   
    
    [_imageHeader setImageWithURLString:model.userImg];
    NSString *content = model.content;
    _labContent.lineBreakMode = NSLineBreakByCharWrapping;
    _labContent.numberOfLines=0;
    _labContent.text = content;
    CGRect frame = _labContent.frame;
    [_btnPraise setTitle:[NSString stringWithFormat:@"%d",model.vote] forState:UIControlStateNormal];
    
    if(model.vote>0)
    {
        [_btnPraise setImage:[UIImage imageNamed:@"praiseBlue.png"] forState:UIControlStateNormal];
    }
//    _labPraise.text=[NSString stringWithFormat:@"%d",model.vote];
    
    frame.size.height = [content heightWithFont:_labContent.font constrainedToWidth:CGRectGetWidth(frame)];
    _labContent .frame = frame;
    [self.labTime setText:model.gmtCreate];
    _labContent.lineBreakMode= NSLineBreakByTruncatingTail;
    [self.staticStarRatingView setSelectedIndex:model.rank];
    
_labTitle.text=model.userNickname;
    
    [_btnComment setTitle:[NSString stringWithFormat:@"%d",model.arrReplyList.count] forState:UIControlStateNormal];

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
        frame.origin.y = CGRectGetMaxY(_labContent.frame) + 5;
        _contentImageView.frame = frame;
    }
    else
    {
        _contentImageView.hidden=YES;
    }
    
    CGRect mainFrame=self.frame;
    mainFrame.size.height=(model.imgList.count==0?CGRectGetMaxY(_labContent.frame):CGRectGetMaxY(_contentImageView.frame))+30;
    self.frame=mainFrame;

}






- (IBAction)btnCommentClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(clickCellComment:)])
    {
        [_delegate clickCellComment:self];
    }

}

- (IBAction)btnPraiseClick:(id)sender {
    
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.3f];
    

}





- (void)todoSomething:(id)sender
{
    //在这里做按钮的想做的事情。
    
    
    if(_delegate && [_delegate respondsToSelector:@selector(clickVote:)])
    {
        [_delegate clickVote:self];
    }
    
    //   //
    
    
    
}





@end

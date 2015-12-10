//
//  ReplyListCell.m
//  JuranClient
//
//  Created by 123 on 15/11/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ReplyListCell.h"

@implementation ReplyListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setData:(JRReplyModel *)model
{
    _model=model;
    //    NSString *content = model.content;
    //    _labContent.lineBreakMode = NSLineBreakByCharWrapping;
    //    _labContent.numberOfLines=0;
    //    _labContent.text = content;
    CGRect frame = _labContent.frame;
    
    _labTitle.text=model.userNickname;
    
    
    
    [self.labTime setText:model.gmtCreate];
    
    
    //    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:frame];
    _labContent.textColor = [UIColor blackColor];
    _labContent.font = [UIFont systemFontOfSize:13];
    _labContent.backgroundColor = [UIColor clearColor];
    _labContent.numberOfLines = 0;
//    NSString *name = [NSString stringWithFormat:@"%@",_model.userNickname];
    _labContent.lineSpacing=8;
    NSString *replyNickname=_model.replyNickname;
    NSString *content=_model.content;
    if(replyNickname!=nil && replyNickname!=NULL && ![replyNickname isEqual:@""])
    {
        content = [NSString stringWithFormat:@"回复%@:%@", replyNickname,_model.content];
    }
    
    
    //    NSString *content = [NSString stringWithFormat:@"%@回复%@:%@", name, replyNickname,_model.content];
    
    frame.size.height = [content heightWithFont:_labContent.font constrainedToWidth:CGRectGetWidth(frame)];
    _labContent .frame = frame;
    
    [_labContent setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:replyNickname options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[RGBColor(138, 138, 138) CGColor] range:range];
        
       

        return mutableAttributedString;
    }];
    //
    
    
    //    CGRect mainFrame=self.frame;
    //    mainFrame.size.height=(model.imgList.count==0?CGRectGetMaxY(_labContent.frame):CGRectGetMaxY(_contentImageView.frame))+10;
    //    self.frame=mainFrame;
    
}

- (IBAction)btnReplyClick:(id)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(reply:)])
    {
                       
        [_delegate reply:self.model];
    }
}


@end

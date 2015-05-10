//
//  ReplyView.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/4.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ReplyView.h"
#import "JRComment.h"
#import "TTTAttributedLabel.h"
#import "ZoomInImageView.h"

@interface ReplyView ()

@end

@implementation ReplyView

- (instancetype)initWithComments:(NSArray *)comments{
    CGRect frame = CGRectMake(0, 0, 290, 0);
    self.userInteractionEnabled = YES;
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setReplys:(NSArray *)replys{
    
    _replys = replys;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    if (replys.count == 0) {
        return;
    }
    
    CGRect frame = CGRectMake(0, 0, 290, 0);
    
    frame.size.height = 1;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:frame];
    lineImageView.backgroundColor = RGBColor(223, 223, 223);
    [self addSubview:lineImageView];
    
    for (JRComment *comment in replys) {
        frame.origin.y = CGRectGetMaxY(frame) + 10;
        TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:frame];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        NSString *name = [NSString stringWithFormat:@"%@：", comment.nickName];
        NSString *content = [NSString stringWithFormat:@"%@%@", name, comment.replyContent];
        frame.size.height = [content heightWithFont:label.font constrainedToWidth:CGRectGetWidth(frame)];
        label.frame = frame;
        [label setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange range = [[mutableAttributedString string] rangeOfString:name options:NSCaseInsensitiveSearch];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[kBlueColor CGColor] range:range];
            return mutableAttributedString;
        }];
        [self addSubview:label];
        
        frame.origin.y = CGRectGetMaxY(frame) + 10;
        frame.size.height = 10;
        UILabel *timeLabel = [self labelWithFrame:frame text:comment.replyTime textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:10]];
        [self addSubview:timeLabel];
        
        if (comment.imageUrlList.count > 0) {
            frame.origin.y = CGRectGetMaxY(frame) + 5;
            frame.size.height = 45;
            frame.size.width = 60;
            NSInteger i = 0;
            for (NSString *str in comment.imageUrlList) {
                ZoomInImageView *imageView = [[ZoomInImageView alloc] initWithFrame:CGRectMake(frame.origin.x+68*i, frame.origin.y, 60, 45)];
                imageView.image = [UIImage imageNamed:@"image_default.png"];
                [imageView setImageWithURLString:str];
                [self addSubview:imageView];
                i++;
            }
            frame.size.width = label.frame.size.width;
        }
    }
    
    self.height = CGRectGetMaxY(frame) + 10;
    frame = self.frame;
    frame.size.height = _height;
    self.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  CommentStarView.m
//  JuranClient
//
//  Created by HuangKai on 15/2/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CommentStarView.h"

@implementation CommentStarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)awakeFromNib{
    [self configureView];
}

- (void)configureView{
    CGFloat xMargin = 36;
    CGFloat yMargin = 36;
    yMargin = CGRectGetHeight(self.frame);
    xMargin = CGRectGetWidth(self.frame)/5;
    for (NSInteger i = 1; i < 6; i++) {
        UIButton *btn = [self buttonWithFrame:CGRectMake((i - 1) * xMargin, 0, xMargin, yMargin) target:self action:@selector(onSelected:) image:[UIImage imageNamed:@"order_star_unselected.png"]];
        btn.tag = 1100 + i;
        [self addSubview:btn];
    }
}

- (void)onSelected:(id)sender{
    UIButton *btn = (UIButton*)sender;
    _selectedIndex = btn.tag - 1100;
    for (NSInteger i = 1; i < 6; i++) {
        UIButton *b = (UIButton*)[self viewWithTag:1100 + i ];
        if (i <= _selectedIndex) {
            [b setImage:[UIImage imageNamed:@"order_star_selected.png"] forState:UIControlStateNormal];
        }else{
            [b setImage:[UIImage imageNamed:@"order_star_unselected.png"] forState:UIControlStateNormal];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedStarView:)]) {
        [_delegate didSelectedStarView:self];
    }
}

- (void)setEnable:(BOOL)isEnadbel{
    self.userInteractionEnabled = isEnadbel;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    for (NSInteger i = 1; i < 6; i++) {
        UIButton *b = (UIButton*)[self viewWithTag:1100 + i ];
        if (i <= _selectedIndex) {
            [b setImage:[UIImage imageNamed:@"order_star_selected.png"] forState:UIControlStateNormal];
        }else{
            [b setImage:[UIImage imageNamed:@"order_star_unselected.png"] forState:UIControlStateNormal];
        }
    }
}

@end

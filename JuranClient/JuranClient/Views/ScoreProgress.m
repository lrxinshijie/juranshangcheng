//
//  ScoreProgress.m
//  JuranClient
//
//  Created by HuangKai on 15/3/4.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ScoreProgress.h"

@interface ScoreProgress()

@property (nonatomic, strong) UIView *indexView;

@end

@implementation ScoreProgress

- (id)init{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib{
    [self configure];
}

- (void)configure{
    self.backgroundColor = RGBColor(225, 227, 232);
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.clipsToBounds = YES;
    
    self.indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
    _indexView.backgroundColor = RGBColor(83, 133, 202);
//    _indexView.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    [self addSubview:_indexView];
    
    for (NSInteger i = 1; i < 5; i ++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/5 * i, 0, .5f, CGRectGetHeight(self.frame))];
        line.backgroundColor = RGBColor(190, 193, 198);
        [self addSubview:line];
    }
}

- (void)setSelectedIndex:(CGFloat)selectedIndex{
    _selectedIndex = selectedIndex;
    CGRect frame = _indexView.frame;
    frame.size.width = (selectedIndex > 1?1 : selectedIndex) * CGRectGetWidth(self.frame);
    _indexView.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

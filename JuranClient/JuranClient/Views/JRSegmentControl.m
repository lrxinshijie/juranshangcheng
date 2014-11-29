//
//  JRSegmentControl.m
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRSegmentControl.h"

#define  kButtonTag  1000

@interface JRSegmentControl()

@property (nonatomic, strong) UIView *selectedBackgroundView;

@end

@implementation JRSegmentControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTitleList:(NSArray *)titleList{
    _titleList = titleList;
    NSInteger i = 0;
    for (NSString *title in _titleList) {
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame)/_titleList.count*i, 0, CGRectGetWidth(self.frame)/_titleList.count, CGRectGetHeight(self.frame));
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kButtonTag+i;
        btn.frame = frame;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:kSystemFontSize+2];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:35/255.f green:104/255.f blue:182/255.f alpha:1.0f] forState:UIControlStateSelected];
        [self addSubview:btn];
        i++;
    }
    
    UIButton *selectedBtn = (UIButton*)[self viewWithTag:kButtonTag];
    _selectedIndex = 0;
    [selectedBtn setSelected:YES];
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.frame) - 2, CGRectGetWidth(selectedBtn.frame), 2);
    _selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    _selectedBackgroundView.backgroundColor = [UIColor colorWithRed:35/255.f green:104/255.f blue:182/255.f alpha:1.0f];
    [self insertSubview:_selectedBackgroundView atIndex:0];
}

- (void)onSelected:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag - kButtonTag;
    if (index != _selectedIndex) {
        [UIView animateWithDuration:.3f animations:^{
            CGRect frame = _selectedBackgroundView.frame;
            frame.origin.x = btn.frame.origin.x;
            _selectedBackgroundView.frame = frame;
        } completion:^(BOOL finished) {
            [(UIButton*)[self viewWithTag:kButtonTag+_selectedIndex] setSelected:NO];
            [btn setSelected:YES];
            _selectedIndex = index;
            if ([self.delegate respondsToSelector:@selector(segmentControl:changedSelectedIndex:)]) {
                [self.delegate segmentControl:self changedSelectedIndex:index];
            }
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

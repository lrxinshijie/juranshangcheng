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
        CGRect frame;
        if (_isDesigner) {
            frame = CGRectMake(95*i, 0, 95, CGRectGetHeight(self.frame));
            if (i == _titleList.count - 1) {
                frame = CGRectMake(95*i, 0, CGRectGetWidth(self.frame) - 95*i, CGRectGetHeight(self.frame));
            }
        }else{
            frame = CGRectMake(CGRectGetWidth(self.frame)/titleList.count * i, 0, CGRectGetWidth(self.frame)/titleList.count, CGRectGetHeight(self.frame));
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kButtonTag+i;
        btn.frame = frame;
        btn.titleLabel.font = [UIFont systemFontOfSize:kSystemFontSize+(_isDesigner?2:0)];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:35/255.f green:104/255.f blue:182/255.f alpha:1.0f] forState:UIControlStateSelected];
        [self addSubview:btn];
        
        if (_showVerticalSeparator) {
            if (i < _titleList.count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(frame), 0, 1, CGRectGetHeight(frame))];
                line.backgroundColor = RGBColor(229, 229, 229);
                [self addSubview:line];
            }
        }
        
        i++;
    }
    
    if (_showUnderLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1)];
        line.backgroundColor = RGBColor(229, 229, 229);
        [self addSubview:line];
    }
    
    UIButton *selectedBtn = (UIButton*)[self viewWithTag:kButtonTag];
    _selectedIndex = 0;
    [selectedBtn setSelected:YES];
    
    CGRect frame = CGRectMake(_selectedBackgroundViewXMargin, CGRectGetHeight(self.frame) - 2, CGRectGetWidth(selectedBtn.frame)-2*_selectedBackgroundViewXMargin, 2);
    _selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    _selectedBackgroundView.backgroundColor = [UIColor colorWithRed:35/255.f green:104/255.f blue:182/255.f alpha:1.0f];
    _selectedBackgroundView.hidden = _showVerticalSeparator;
    [self insertSubview:_selectedBackgroundView atIndex:0];
}

- (void)onSelected:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag - kButtonTag;
    if (index != _selectedIndex) {
        [UIView animateWithDuration:.3f animations:^{
            CGRect frame = _selectedBackgroundView.frame;
            frame.origin.x = btn.frame.origin.x+_selectedBackgroundViewXMargin;
            frame.size.width = btn.frame.size.width - 2*_selectedBackgroundViewXMargin;
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


- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex < _titleList.count && selectedIndex >= 0) {
        [self onSelected:[self viewWithTag:kButtonTag + selectedIndex]];
    }
}

- (NSInteger)numberOfSegments{
    return _titleList.count;
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

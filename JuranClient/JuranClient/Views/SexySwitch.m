//
//  SexySwitch.m
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SexySwitch.h"

@interface SexySwitch()

@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation SexySwitch

- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 75, 32)];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.f;
        self.backgroundColor = RGBColor(101, 210, 117);
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
        _backgroundView.layer.cornerRadius = 2.0f;
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundView];
        
        _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_maleBtn setTitleColor:RGBColor(101, 210, 117) forState:UIControlStateSelected];
        [_maleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kSystemFontSize]];
        [_maleBtn addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_maleBtn];
        
        _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleBtn.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
        [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:RGBColor(101, 210, 117) forState:UIControlStateSelected];
        [_femaleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kSystemFontSize]];
        [_femaleBtn addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_femaleBtn];
        
        self.selectedIndex = 0;
    }
    return self;
}

- (void)onSelected:(id)sender{
    NSInteger index;
    if (sender == _maleBtn) {
        index = 0;
    }else{
        index = 1;
    }
    if (_selectedIndex == index) {
        return;
    }
    self.selectedIndex =index;
    if ([_delegate respondsToSelector:@selector(sexySwitch:valueChange:)]) {
        [_delegate sexySwitch:self valueChange:_selectedIndex];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    UIButton *btn = selectedIndex?_femaleBtn:_maleBtn;
    UIButton *otherBtn = selectedIndex?_maleBtn:_femaleBtn;
    [UIView animateWithDuration:.3f animations:^{
        _backgroundView.center = btn.center;
    } completion:^(BOOL finished) {
    }];
    [btn setSelected:YES];
    [otherBtn setSelected:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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

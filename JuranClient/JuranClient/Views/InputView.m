//
//  InputView.m
//  JuranClient
//
//  Created by HuangKai on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "InputView.h"
#import "AppDelegate.h"

@interface InputView()<UITextViewDelegate>

@property (nonatomic, copy) FinishBlock block;
@property (nonatomic, strong) ASPlaceholderTextView *contentTextView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation InputView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.frame = kContentFrameWithoutNavigationBar;
        self.backgroundColor = RGBAColor(0, 0, 0, .5f);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
        
        UIButton *btn = [self buttonWithFrame:self.frame target:self action:@selector(onHidden) image:nil];
        [self addSubview:btn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 150)];
        self.contentView.backgroundColor = RGBColor(237, 237, 237);
        [self addSubview:self.contentView];
        _contentView.center = CGPointMake(self.center.x, self.center.y - 50);
        
        btn = [self buttonWithFrame:CGRectMake(0, 0, 40, 40) target:self action:@selector(onCancel) image:[UIImage imageNamed:@"icon_check_cancel.png"]];
        [self.contentView addSubview:btn];
        
        btn = [self buttonWithFrame:CGRectMake(kWindowWidth - 40, 0, 40, 40) target:self action:@selector(onOK) image:[UIImage imageNamed:@"icon_check_ok.png"]];
        [self.contentView addSubview:btn];
        
        self.titleLabel = [self labelWithFrame:CGRectMake(60, 10, kWindowWidth - 120, 20) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_titleLabel];
        
        self.contentTextView = [[ASPlaceholderTextView alloc] initWithFrame:CGRectMake(15, 40, kWindowWidth - 30, 95)];
        [self.contentView addSubview:_contentTextView];
    }
    return self;
}

- (void)onHidden{
    [self.contentTextView resignFirstResponder];
}

- (void)onCancel{
    
    [self unShow];
}

- (void)onOK{
    if (self.block) {
        _block(_contentTextView.text);
    }
    [self unShow];
}

- (void)showWithTitle:(NSString*)title placeHolder:(NSString*)place content:(NSString*)content block:(FinishBlock)finished{
    self.titleLabel.text = title;
    self.contentTextView.placeholder = place;
    self.contentTextView.text = content;
    
    self.block = finished;
    self.hidden = NO;
}



- (void)unShow{
    [_contentTextView resignFirstResponder];
    self.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = _contentView.frame;
        frame.origin.y = self.frame.size.height - keyboardSize.height - CGRectGetHeight(_contentView.frame);
        _contentView.frame = frame;
    });
//    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    _contentView.center = CGPointMake(self.center.x, self.center.y - 50);
}


@end

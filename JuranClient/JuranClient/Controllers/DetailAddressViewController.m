//
//  DetailAddressViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DetailAddressViewController.h"
#import "JRDesigner.h"

@interface DetailAddressViewController ()<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *textVeiw;

@end

@implementation DetailAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    _textVeiw.delegate = self;
    
    if (_type == 0) {
        self.navigationItem.title = @"详细地址";
        _textVeiw.placeholder = @"请输入详细地址";
        _textVeiw.text = _user.detailAddress;
    }
#ifdef kJuranDesigner
    else if (_type == 1){
        self.navigationItem.title = @"自我介绍";
        _textVeiw.placeholder = @"请输入自我介绍";
        _textVeiw.text = _user.selfIntroduction;
    }else if (_type == 2){
        self.navigationItem.title = @"证书与奖项";
        _textVeiw.placeholder = @"请输入证书与奖项";
        _textVeiw.text = _user.personalHonor;
    }
#endif
    
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave:) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)onSave:(id)sender{
    if (_type == 0) {
        _user.detailAddress = _textVeiw.text;
    }
#ifdef kJuranDesigner
    else if (_type == 1){
        _user.selfIntroduction = _textVeiw.text;
    }else if (_type == 2){
        _user.personalHonor = _textVeiw.text;
    }
#endif
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
//    [self modifyMemberDetail];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isContainsEmoji]) {
        return NO;
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (_type == 0) {
        if ([Public convertToInt:toBeString] >= 60) {
            [_textVeiw resignFirstResponder];
            [self showTip:@"输入地址长度不能超过60!"];
            return NO;
        }
    }
#ifdef kJuranDesigner
    else if (_type == 1){
    }
#endif
    return YES;
}

@end

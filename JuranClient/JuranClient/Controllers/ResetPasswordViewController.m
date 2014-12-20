//
//  ResetPasswordViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)onSubmit:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onBack:(id)sender;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
}

- (IBAction)onSubmit:(id)sender{
    [self onHideKeyboard:sender];
    
    NSString *password = _passwordTextField.text;
    NSString *confirm = _confirmPasswordTextField.text;
    if (password.length == 0 || confirm.length == 0) {
        [self showTip:@"密码不能为空"];
        return;
    }
    if (![password isEqualToString:confirm]) {
        [self showTip:@"两次密码不一致"];
        return;
    }
    
    NSDictionary *param = @{@"guid": _guid,
                            @"token": _token,
                            @"password": password};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_RESET_PWD parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
}

- (IBAction)onHideKeyboard:(id)sender{
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
}

- (IBAction)onBack:(id)sender{
    [super back:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (value.length > kPasswordMaxNumber) {
        return NO;
    }
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

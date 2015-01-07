//
//  SetPasswordViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "AppDelegate.h"

@interface SetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)onRegist:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onBack:(id)sender;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    _phoneTextField.text = _phone;
    _phoneTextField.enabled = NO;
    
    [_phoneTextField configurePlaceholderColor:[UIColor whiteColor]];
    [_passwordTextField configurePlaceholderColor:[UIColor whiteColor]];
    [_confirmPasswordTextField configurePlaceholderColor:[UIColor whiteColor]];
}

- (IBAction)onBack:(id)sender{
    [super back:sender];
}

- (IBAction)onRegist:(id)sender{
    [self onHideKeyboard:sender];
    
    NSString *password = _passwordTextField.text;
    NSString *confirm = _confirmPasswordTextField.text;
    if (password.length == 0 || confirm.length == 0) {
        [self showTip:@"密码不能为空"];
        return;
    }
    
    if (password.length < 6 || confirm.length < 6) {
        [self showTip:@"密码不能少于6位"];
        return;
    }
    
    if (![password isEqualToString:confirm]) {
        [self showTip:@"两次密码不一致"];
        return;
    }
    
    NSDictionary *param = @{@"userType": @"member",
                            @"mobileNum": _phone,
                            @"regType" : @"telephone",
                            @"password": password,
                            @"smsAuthNo": _code,
                            @"pushId": ApplicationDelegate.clientId,
                            @"deviceInfo":[Public deviceInfo]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REGISTUSER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            JRUser *user = [[JRUser alloc] initWithDictionary:data];
            user.account = _phone;
            user.password = password;
            [user saveLocal];
            [user resetCurrentUser];
            
            if (_block) {
                _block();
            }
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        }
    }];
    
}

- (IBAction)onHideKeyboard:(id)sender{
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_passwordTextField]) {
        [_confirmPasswordTextField becomeFirstResponder];
    }else{
        [self onRegist:nil];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
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

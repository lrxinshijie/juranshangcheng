//
//  LoginViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

- (IBAction)onBack:(id)sender;
- (IBAction)onThirdLogin:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onRegist:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onForget:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender{
    [super back:sender];
}

- (IBAction)onThirdLogin:(id)sender{
    [self onHideKeyboard:sender];
}

- (IBAction)onLogin:(id)sender{
    [self onHideKeyboard:sender];
    
    NSString *account = _accountTextField.text;
    NSString *password = _passwordTextField.text;
    
    if (account.length == 0 || password.length == 0) {
        [self showTip:@"帐户或密码不能为空"];
        return;
    }
    NSDictionary *param = @{@"account": account,
                            @"password": [NSString stringWithFormat:@"%@", password]
//                            @"pushID": @"1111",
//                            @"DeviceInfo": @"iPhone",
//                            @"DeviceInfo/appType": @"11",
//                            @"DeviceInfo/version": @"1.0",
//                            @"DeviceInfo/deviceType": @"iPhone",
//                            @"DeviceInfo/OSVersion": @"8.0"
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_LOGIN parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            JRUser *user = [[JRUser alloc] initWithDictionary:data];
            user.account = account;
            user.password = password;
            [user saveLocal];
            [user resetCurrentUser];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self back:nil];
            });
        }
    }];
}

- (IBAction)onRegist:(id)sender{
    [self onHideKeyboard:sender];
    RegistViewController *rv = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:rv animated:YES];
}

- (IBAction)onHideKeyboard:(id)sender{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_accountTextField]) {
        [_passwordTextField becomeFirstResponder];
    }else{
        [self onLogin:nil];
    }
    
    return YES;
}

- (IBAction)onForget:(id)sender{
    ForgetViewController *forget = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
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

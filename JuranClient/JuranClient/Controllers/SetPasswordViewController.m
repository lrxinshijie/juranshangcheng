//
//  SetPasswordViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()

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
    if (![password isEqualToString:confirm]) {
        [self showTip:@"两次密码不一致"];
        return;
    }
    
    NSDictionary *param = @{@"userType": @"member",
                            @"mobileNum": _phone,
                            @"regType" : @"telephone",
                            @"password": password,
                            @"smsAuthNo": _code};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REGISTUSER parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            JRUser *user = [[JRUser alloc] initWithDictionary:data];
            user.account = _phone;
            user.password = password;
            [user saveLocal];
            [user resetCurrentUser];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

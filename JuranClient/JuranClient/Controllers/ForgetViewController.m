//
//  ForgetViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/11/29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ForgetViewController.h"
#import "ResetPasswordViewController.h"
#import "ResetEmailViewController.h"

@interface ForgetViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *emailView;
@property (nonatomic, strong) IBOutlet UIView *phoneView;

@property (nonatomic, strong) IBOutlet UIButton *emailButton;
@property (nonatomic, strong) IBOutlet UIButton *phoneButton;
@property (nonatomic, strong) IBOutlet UIButton *codeButton;

@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *codeTextField;
@property (nonatomic, assign) BOOL isPhone;
@property (nonatomic, assign) NSInteger currentTime;

- (IBAction)onPhone:(id)sender;
- (IBAction)onEmail:(id)sender;
- (IBAction)onCode:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onPhoneSubmit:(id)sender;
- (IBAction)onEmailSubmit:(id)sender;
- (IBAction)onHideKeyBoard:(id)sender;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    _emailView.backgroundColor = [UIColor clearColor];
    _phoneView.backgroundColor = [UIColor clearColor];
    
    _emailButton.layer.masksToBounds = YES;
    _emailButton.layer.cornerRadius = 5;
    _phoneButton.layer.masksToBounds = YES;
    _phoneButton.layer.cornerRadius = 5;
    
    CGRect frame = _emailView.frame;
    frame.origin = CGPointMake(20, 110);
    _emailView.frame = frame;
    
    frame = _phoneView.frame;
    frame.origin = CGPointMake(20, 110);
    _phoneView.frame = frame;
    
    self.isPhone = YES;
}

- (void)setIsPhone:(BOOL)isPhone{
    _isPhone = isPhone;

    [_emailView removeFromSuperview];
    [_phoneView removeFromSuperview];
    
    if (_isPhone) {
        [self.view addSubview:_phoneView];
        _emailButton.backgroundColor = [UIColor clearColor];
        _phoneButton.backgroundColor = RGBColor(14, 80, 172);
        
    }else{
        [self.view addSubview:_emailView];
        _emailButton.backgroundColor = RGBColor(14, 80, 172);
        _phoneButton.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCurrentTime:(NSInteger)currentTime{
    _currentTime = currentTime;
    if (currentTime == 0) {
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:RGBColor(0, 70, 165) forState:UIControlStateNormal];
        _codeButton.enabled = YES;
    }else{
        _codeButton.enabled = NO;
        [_codeButton setTitle:[NSString stringWithFormat:@"%d秒",_currentTime] forState:UIControlStateNormal];
        [_codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:NO];
    }
}

- (void)changeTime{
    self.currentTime = _currentTime - 1;
}

- (IBAction)onPhone:(id)sender{
    if (!_isPhone) {
        self.isPhone = YES;
    }
}
- (IBAction)onEmail:(id)sender{
    if (_isPhone) {
        self.isPhone = NO;
    }
    
}

- (IBAction)onCode:(id)sender{
    [self onHideKeyBoard:sender];
    
    NSString *phone = _phoneTextField.text;
    if (phone.length != 11) {
        [self showTip:@"手机号码格式不正确"];
        return;
    }
    
    NSDictionary *param = @{@"mobileNum": phone,
                            @"mobileType": @"P02"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REGIST_SENDSMS parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:[NSString stringWithFormat:@"已将验证发送至%@",phone]];
            self.currentTime = 60;
        }
    }];
}

- (IBAction)onBack:(id)sender{
    [super back:sender];
}

- (IBAction)onPhoneSubmit:(id)sender{
    [self onHideKeyBoard:sender];
    
    NSString *phone = _phoneTextField.text;
    NSString *code = _codeTextField.text;
    if (phone.length != 11) {
        [self showTip:@"手机号码格式不正确"];
        return;
    }
    
    
    if (code.length == 0) {
        [self showTip:@"验证码错误"];
        return;
    }
    
    NSDictionary *param = @{@"mobileNum": phone,
                            @"smsAuthNo": code
                            //,@"mobileType": @"P02"
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_TOKEN_FOR_RESET_PWD parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ResetPasswordViewController *st = [[ResetPasswordViewController alloc] init];
                st.token = [data getStringValueForKey:@"token" defaultValue:@""];
                st.guid = [data getStringValueForKey:@"guid" defaultValue:@""];
                [self.navigationController pushViewController:st animated:YES];
            });
        }
    }];
}

- (IBAction)onEmailSubmit:(id)sender{
    [self onHideKeyBoard:sender];
    NSString *email = _emailTextField.text;
    if (![email validateEmail]) {
        [self showTip:@"邮箱格式不正确"];
        return;
    }
    
    NSDictionary *param = @{@"email": email};
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_PWD_EMAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ResetEmailViewController *re = [[ResetEmailViewController alloc] init];
                [self.navigationController pushViewController:re animated:YES];
            });
        }
    }];
}

- (IBAction)onHideKeyBoard:(id)sender{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

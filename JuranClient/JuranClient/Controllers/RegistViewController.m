//
//  RegistViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/11/26.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "RegistViewController.h"
#import "ServiceViewController.h"
#import "SetPasswordViewController.h"

@interface RegistViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *codeTextField;
@property (nonatomic, strong) IBOutlet UIButton *checkButton;
@property (nonatomic, strong) IBOutlet UIButton *codeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) BOOL isAgress;

- (IBAction)onCode:(id)sender;
- (IBAction)onRegist:(id)sender;
- (IBAction)onCheck:(id)sender;
- (IBAction)onService:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onBack:(id)sender;

@end

@implementation RegistViewController

- (void)dealloc{
    [_timer invalidate]; _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.isAgress = YES;
    
}

- (void)setIsAgress:(BOOL)isAgress{
    _isAgress = isAgress;
    [_checkButton setImage:[UIImage imageNamed:_isAgress ? @"check-off" : @"check-on"] forState:UIControlStateNormal];
}

- (IBAction)onBack:(id)sender{
    [super back:sender];
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
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:NO];
    }
}

- (void)changeTime{
    self.currentTime = _currentTime - 1;
}

- (IBAction)onCode:(id)sender{
    [self onHideKeyboard:sender];
    
    NSString *phone = _phoneTextField.text;
    if (phone.length != 11) {
        [self showTip:@"手机号码格式不正确"];
        return;
    }
    
    NSDictionary *param = @{@"mobileNum": phone,
                            @"mobileType": @"P01"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REGIST_SENDSMS parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:[NSString stringWithFormat:@"已将验证发送至%@",phone]];
            self.currentTime = 60;
        }
    }];
}

- (IBAction)onRegist:(id)sender{
    [self onHideKeyboard:sender];
    
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
    
    if (!_isAgress) {
        [self showTip:@"请同意服务协议"];
        return;
    }
    
    NSDictionary *param = @{@"mobileNum": phone,
                            @"smsAuthNo": code,
                            @"mobileType": @"P01"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_VALIDSMS parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SetPasswordViewController *st = [[SetPasswordViewController alloc] init];
                st.phone = phone;
                st.code = code;
                [self.navigationController pushViewController:st animated:YES];
            });
        }
    }];
}

- (IBAction)onCheck:(id)sender{
    self.isAgress = !_isAgress;
}

- (IBAction)onService:(id)sender{
    ServiceViewController *sv = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:sv animated:YES];
}

- (IBAction)onHideKeyboard:(id)sender{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
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

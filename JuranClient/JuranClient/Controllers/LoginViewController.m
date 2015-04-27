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
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "WXApi.h"
@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *qqButton;
@property (nonatomic, strong) IBOutlet UIButton *sinaButton;
@property (nonatomic, strong) IBOutlet UIButton *wxButton;

- (IBAction)onBack:(id)sender;
- (IBAction)onThirdLogin:(UIButton *)btn;
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
    
    [_passwordTextField configurePlaceholderColor:[UIColor whiteColor]];
    [_accountTextField configurePlaceholderColor:[UIColor whiteColor]];
    
#ifdef kJuranDesigner
    _qqButton.hidden = YES;
    
    if (![WXApi isWXAppInstalled]) {
        _wxButton.hidden = YES;
        CGRect frame = _sinaButton.frame;
        frame.origin.x = (kWindowWidth-CGRectGetWidth(frame))/2;
        _sinaButton.frame = frame;
    }else{
        CGRect frame = _sinaButton.frame;
        frame.origin.x = 67;
        _sinaButton.frame = frame;
        
        frame = _wxButton.frame;
        frame.origin.x = 193;
        _wxButton.frame = frame;
    }
    
#endif
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

- (IBAction)onThirdLogin:(UIButton *)btn{
    [self onHideKeyboard:btn];
    
    ShareType type = ShareTypeQQSpace;
    if (btn.tag == 1001) {
        type = ShareTypeSinaWeibo;
    }else if (btn.tag == 1003){
        type = ShareTypeWeixiSession;
    }
//    if (![[ShareSDK getClientWithType:type]isClientInstalled]) {
//        if (type == ShareTypeQQSpace) {
//            [Public alertOK:nil Message:@"尚未安装QQ客户端，请安装后重试"];
//        }else if(type == ShareTypeSinaWeibo){
//            [Public alertOK:nil Message:@"尚未安装新浪微博客户端，请安装后重试"];
//        }else if(type == ShareTypeWeixiSession){
//            [Public alertOK:nil Message:@"尚未安装微信客户端，请安装后重试"];
//        }
//        return;
//    };
    
    ASLog(@"version:%@", [ShareSDK version]);
    [ShareSDK cancelAuthWithType:type];
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result){
            ASLog(@"userInfo:%@",userInfo.sourceData);
            NSString *thirdUserId = [[userInfo credential] uid];
            NSString *nickName = [userInfo nickname];
//            NSString *accessToken = [[userInfo credential] token];
//            NSNumber *thirdSource = @(2);
            NSNumber *thirdSource = @(0);
            if (type == ShareTypeSinaWeibo) {
                thirdSource = @(1);
            } else if (type == ShareTypeWeixiSession) {
                thirdSource = @(3);
                thirdUserId = [userInfo.sourceData getStringValueForKey:@"unionid" defaultValue:@""];
            } else if (type == ShareTypeQQSpace) {
                thirdSource = @(2);
            }
            
            NSDictionary *param = @{@"userType": [[ALTheme sharedTheme] userType],
                                    @"thirdUserId":thirdUserId,
                                    @"thirdSource": thirdSource,
                                    @"nickName": nickName,
                                    @"pushId": ApplicationDelegate.clientId,
                                    @"deviceInfo":[Public deviceInfo]};
            [self showHUD];
            [[ALEngine shareEngine] pathURL:JR_THIRD_LOGIN parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self hideHUD];
                if (!error) {
                    JRUser *user = [[JRUser alloc] initWithDictionary:data];
//                    user.account = account;
//                    user.password = password;
                    [user saveLocal];
                    [user resetCurrentUser];
                    if (_block) {
                        _block();
                    }
#ifdef kJuranDesigner
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
#endif
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self back:nil];
                    });
                }
            }];
        }else{
            [self showTip:error.errorDescription];
        }
    }];
    
}

- (IBAction)onLogin:(id)sender{
    [self onHideKeyboard:sender];
    
    NSString *account = _accountTextField.text;
    NSString *password = _passwordTextField.text;

    if (account.length == 0 || password.length == 0) {
        [self showTip:@"帐户或密码不能为空"];
        return;
    }
    if (password.length < 6) {
        [self showTip:@"密码需要大于6位"];
        return;
    }
    
    NSDictionary *param = @{@"account": account,
                            @"password": [NSString stringWithFormat:@"%@", password],
                            @"pushId": ApplicationDelegate.clientId,
                            @"deviceInfo":[Public deviceInfo],
                            @"userType": [[ALTheme sharedTheme] userType]
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_LOGIN parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@(NO)} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            JRUser *user = [[JRUser alloc] initWithDictionary:data];
            user.account = account;
            user.password = password;
            [user saveLocal];
            [user resetCurrentUser];
            
            if (_block) {
                _block();
            }
#ifdef kJuranDesigner
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
#endif
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self back:nil];
            });
        }
    }];
}

- (IBAction)onRegist:(id)sender{
    [self onHideKeyboard:sender];
    RegistViewController *rv = [[RegistViewController alloc] init];
    rv.block = _block;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:_accountTextField] && value.length > kAccountMaxNumber) {
        return NO;
    }else if ([textField isEqual:_passwordTextField] && value.length > kPasswordMaxNumber){
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

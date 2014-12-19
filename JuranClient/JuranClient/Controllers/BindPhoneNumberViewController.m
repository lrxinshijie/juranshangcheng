//
//  BindPhoneNumberViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "BindPhoneNumberViewController.h"

@interface BindPhoneNumberViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    //1为解绑手机  2为绑定新手机
    NSInteger step;
    NSTimer *timer;
    NSInteger counter;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UIView *step10View;
@property (nonatomic, strong) IBOutlet UIView *step11View;
@property (nonatomic, strong) IBOutlet UILabel *oldPhoneLabel;
@property (nonatomic, strong) IBOutlet UIButton *commiteButton;
@property (nonatomic, strong) IBOutlet UIButton *getCaptchaButton;
@property (nonatomic, strong) UILabel *countDownLabel;

@end

@implementation BindPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self setupUI];
    if (_user.mobileNum && _user.mobileNum.length > 0) {
        step = 1;
    }else{
        step = 2;
    }
    [self reloadData];
}

- (void)reloadData{
    if (step == 1) {
        self.navigationItem.title = @"安全验证";
        _getCaptchaButton.enabled = YES;
        _phoneTextField.hidden = YES;
        _oldPhoneLabel.hidden = NO;
        _oldPhoneLabel.text = [_user mobileNumForBindPhone];
        [_commiteButton setTitle:@"验证" forState:UIControlStateNormal];
    }else{
        self.navigationItem.title = @"绑定手机号码";
        _phoneTextField.hidden = NO;
        _oldPhoneLabel.hidden = YES;
        _getCaptchaButton.enabled = YES;
        [_commiteButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)setupUI{
    _captchaTextField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -30, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _captchaTextField.placeholder = @"请输入手机短信中的验证码";
    _captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
    _captchaTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *btn = [self.view buttonWithFrame:kContentFrameWithoutNavigationBar target:self action:@selector(onHidden:) image:nil];
    [self.view addSubview:btn];
    
    CGRect frame = CGRectMake(0, 0, kWindowWidth, 44*3);
    self.tableView = [self.view tableViewWithFrame:frame style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
    
    frame = _tableFooterView.frame;
    frame.origin.y = CGRectGetMaxY(_tableView.frame);
    _tableFooterView.frame = frame;
    [self.view addSubview:_tableFooterView];
    
    self.countDownLabel = [self.view labelWithFrame:CGRectMake(kWindowWidth - 100 - 15, kWindowHeightWithoutNavigationBar - 30 -15, 100, 30) text:@"" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:kSystemFontSize]];
    _countDownLabel.layer.masksToBounds = YES;
    _countDownLabel.layer.cornerRadius = 3;
    _countDownLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _countDownLabel.layer.borderWidth = 1;
    _countDownLabel.hidden = YES;
    [self.view addSubview:_countDownLabel];
}

- (void)onHidden:(id)sender{
    [_captchaTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
}

- (IBAction)onCommit:(id)sender{
    if (step == 1) {
        [self unbindCommit];
    }else if (step == 2){
        [self bindCommit];
    }
}

- (void)unbindCommit{
    if (!(_captchaTextField.text && _captchaTextField.text.length > 0)) {
        [self showTip:@"请输入验证码"];
        return;
    }
    NSDictionary *param = @{@"mobileNum": _user.mobileNum,
                            @"smsAuthNo": _captchaTextField.text,
                            @"mobileType": @"P04"};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_VALIDSMS parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken: @"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _countDownLabel.hidden = YES;
                _captchaTextField.text = @"";
                _phoneTextField.text = @"";
                step = 2;
                [self reloadData];
            });
        }
    }];
}

- (void)bindCommit{
    if (!(_captchaTextField.text && _captchaTextField.text.length > 0)) {
        [self showTip:@"请输入验证码"];
        return;
    }
    if (!(_phoneTextField.text && _phoneTextField.text.length > 0)) {
        [self showTip:@"请输入手机号码"];
        return;
    }
    NSDictionary *param = @{@"smsAuthNo":_captchaTextField.text,
                            @"mobileNum":_phoneTextField.text};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_SAVE_MOBILEPHONE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _countDownLabel.hidden = YES;
            _user.mobileNum = _phoneTextField.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)getCaptcha:(id)sender{
    NSDictionary *param = nil;
    if (step == 1) {
        param = @{@"mobileNum": _user.mobileNum,
                  @"mobileType": @"P04"
                  };
    }else if (step == 2){
        if (!(_phoneTextField.text && _phoneTextField.text.length >= 11)) {
            [self showTip:@"请输入完整的手机号码"];
            return;
        }
        [_phoneTextField resignFirstResponder];
        param = @{@"mobileNum": _phoneTextField.text,
                  @"mobileType": @"P03"
                  };
    }
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REGIST_SENDSMS parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self startCountDown];
        }
    }];
}

- (void)startCountDown{
    _countDownLabel.hidden = NO;
    _getCaptchaButton.enabled = NO;
    counter = 60;
    _countDownLabel.text = [NSString stringWithFormat:@"%d秒",counter];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

//倒计时
- (void)countDown{
    dispatch_async(dispatch_get_main_queue(), ^{
        counter--;
        _countDownLabel.text = [NSString stringWithFormat:@"%d秒",counter];
        if (counter <= 0) {
            [timer invalidate];
            timer = nil;
            _countDownLabel.hidden = YES;
            _getCaptchaButton.enabled = YES;
        }
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
    [_captchaTextField resignFirstResponder];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"BindPhoneManage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = RGBColor(108, 108, 108);
        //        cell.detailTextLabel.textColor = RGBColor(69, 118, 187);
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    if (step == 1) {
        if (indexPath.row == 0) {
            cell.accessoryView = _step10View;
            
        }else if (indexPath.row == 1) {
            cell.accessoryView = _step11View;
        }else if (indexPath.row == 2) {
            cell.accessoryView = _captchaTextField;
        }
    }else if (step == 2){
        if (indexPath.row == 0) {
            cell.accessoryView = nil;
            cell.textLabel.text = @"请输入新的手机号码";
            
        }else if (indexPath.row == 1) {
            cell.accessoryView = _step11View;
        }else if (indexPath.row == 2) {
            cell.accessoryView = _captchaTextField;
        }
    }
   
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

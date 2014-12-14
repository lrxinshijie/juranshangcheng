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
    NSInteger step;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UIView *step10View;
@property (nonatomic, strong) IBOutlet UIView *step11View;
@property (nonatomic, strong) IBOutlet UILabel *oldPhoneLabel;
@property (nonatomic, strong) IBOutlet UIButton *commiteButton;

@end

@implementation BindPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self setupUI];
    if (_user.mobileNum && _user.mobileNum.length > 0) {
        step = 1;
        self.navigationItem.title = @"安全验证";
    }else{
        step = 2;
        self.navigationItem.title = @"绑定手机号码";
    }
    [self reloadData];
}

- (void)reloadData{
    if (step == 1) {
        self.navigationItem.title = @"安全验证";
        _phoneTextField.hidden = YES;
        _oldPhoneLabel.hidden = NO;
        _oldPhoneLabel.text = [_user mobileNumForBindPhone];
        [_commiteButton setTitle:@"验证" forState:UIControlStateNormal];
    }else{
        self.navigationItem.title = @"绑定手机号码";
        _phoneTextField.hidden = NO;
        _oldPhoneLabel.hidden = YES;
        [_commiteButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)setupUI{
    _captchaTextField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -30, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _captchaTextField.placeholder = @"请输入手机短信中的验证码";
    _captchaTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = _tableFooterView;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
}

- (IBAction)onCommit:(id)sender{
    if (step == 1) {
        step = 2;
        [self reloadData];
    }else if (step == 2){
        
    }
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
        param = @{@"mobileNum": _phoneTextField.text,
                  @"mobileType": @"P03"
                  };
    }
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_REGIST_SENDSMS parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
        }
    }];
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

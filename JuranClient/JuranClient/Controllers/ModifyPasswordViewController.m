//
//  ModifyPasswordViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *oldPsdTextField;
@property (nonatomic, strong) UITextField *newsPsdTextField;
@property (nonatomic, strong) UITextField *verifyPsdTextField;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"修改密码";
    [self setupUI];
}

- (void)setupUI{
    _oldPsdTextField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -30, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _oldPsdTextField.placeholder = @"当前密码";
    _oldPsdTextField.secureTextEntry = YES;
    _oldPsdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _newsPsdTextField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -30, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _newsPsdTextField.placeholder = @"新密码";
    _newsPsdTextField.secureTextEntry = YES;
    _newsPsdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _verifyPsdTextField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -30, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _verifyPsdTextField.placeholder = @"确认新密码";
    _verifyPsdTextField.secureTextEntry = YES;
    _verifyPsdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBarAndTabBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.tableFooterView = _tableFooterView;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCommit:(id)sender{
    if (!(_oldPsdTextField.text && _oldPsdTextField.text.length > 5)) {
        [self showTip:@"当前密码不能为空"];
        return;
    }
    if (!(_newsPsdTextField.text && _newsPsdTextField.text.length > 5)) {
        [self showTip:@"新密码不能为空"];
        return;
    }
    if (!(_verifyPsdTextField.text && _verifyPsdTextField.text.length > 5)) {
        [self showTip:@"确认密码不能为空"];
        return;
    }
    if (!([_newsPsdTextField.text isEqualToString:_verifyPsdTextField.text])) {
        [self showTip:@"新密码与确认密码不相同"];
        return;
    }
    [self modifyPassword];
}

- (void)modifyPassword{
    NSDictionary *param = @{@"oldPassword": _oldPsdTextField.text,
                            @"password": _newsPsdTextField.text
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_CHANGE_PWD parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JRUser currentUser]logout];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_oldPsdTextField resignFirstResponder];
    [_newsPsdTextField resignFirstResponder];
    [_verifyPsdTextField resignFirstResponder];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AccountManage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = RGBColor(108, 108, 108);
        //        cell.detailTextLabel.textColor = RGBColor(69, 118, 187);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    
    if (indexPath.row == 0) {
        cell.accessoryView = _oldPsdTextField;
        
    }else if (indexPath.row == 1) {
        cell.accessoryView = _newsPsdTextField;
    }else if (indexPath.row == 2) {
        cell.accessoryView = _verifyPsdTextField;
    }
    return cell;
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

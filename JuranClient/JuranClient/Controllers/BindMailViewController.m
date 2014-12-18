//
//  BindMailViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "BindMailViewController.h"

@interface BindMailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    //1为修改绑定邮箱  2为绑定邮箱
    NSInteger step;
    BOOL isSended;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *mailTextField;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) IBOutlet UIView *backgroundView;

@end

@implementation BindMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self setupUI];
    
    if (_user.email && _user.email.length>0) {
        step = 1;
    }else{
        step = 2;
    }
    
    [self reloadData];
}

- (void)setupUI{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeightWithoutNavigationBar)];
    CGPoint center = CGPointMake(bgView.center.x, 220);
    _backgroundView.center = center;
    _backgroundView.hidden = YES;
    [bgView addSubview:_backgroundView];
    [self.view addSubview:bgView];
    
    _mailTextField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -30, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _mailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _mailTextField.placeholder = @"";
    _mailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tableView = [self.view tableViewWithFrame:CGRectMake(0, 0, kWindowWidth, 88) style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
//    _tableView.tableFooterView = _tableFooterView;
    [self.view addSubview:_tableView];
    
    _tableFooterView.frame = CGRectMake(0, 88, kWindowWidth, _tableFooterView.frame.size.height);
    [self.view addSubview:_tableFooterView];
}

- (void)reloadData{
    if (step == 1) {
        self.navigationItem.title = @"安全验证";
        _tipLabel.text = @"点击发送按钮，系统将为您发送一封邮箱变更邮件，您可以通过此邮件修改绑定邮箱地址";
    }else if(step == 2){
        self.navigationItem.title = @"绑定邮箱";
        _tipLabel.text = @"点击发送按钮，系统将为您发送一封邮箱变更邮件，您可以通过此邮件完成邮箱绑定";
    }
    [_tableView reloadData];
}

- (IBAction)onSend:(id)sender{
    if (!(_mailTextField.text && _mailTextField.text.length > 0)) {
        [self showTip:@"请输入电子邮箱"];
        return;
    }
    NSDictionary *param = nil;
    if(step == 1){
        param = @{@"email":_user.email};
    }else if (step == 2){
        param = @{@"email":_mailTextField.text};
    }
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPDATE_BINDINGEMAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            isSended = YES;
            _tableFooterView.hidden = YES;;
            _backgroundView.hidden = NO;
            [_tableView reloadData];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_mailTextField resignFirstResponder];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return isSended?0 : 2;
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
    cell.accessoryView = nil;
    if (indexPath.row == 0) {
        if (step == 1) {
            cell.textLabel.text = @"您当前绑定的邮箱为：";
        }else if (step == 2){
            cell.textLabel.text = @"请输入您的邮箱：";
        }
        
    }else if (indexPath.row == 1) {
        if (step == 1) {
            cell.textLabel.text = _user.email;
        }else if (step == 2){
            cell.accessoryView = _mailTextField;
        }
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

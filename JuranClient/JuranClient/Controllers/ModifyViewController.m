//
//  ModifyViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ModifyViewController.h"
#import "JRMemberDetail.h"
#import "UIActionSheet+Blocks.h"


@interface ModifyViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *idTypes;
    NSInteger idCardType;
    NSDictionary *param;
}
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;

@end

@implementation ModifyViewController

- (id)initWithMemberDetail:(JRUser*)user type:(ModifyCVType)type{    self = [self init];
    if (self) {
        self.user = user;
        self.type = type;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btn = [self.view buttonWithFrame:CGRectMake(0, 0, 44, 30) target:self action:@selector(save) title:@"保存" backgroundImage:nil];
    [btn setTitleColor:[UIColor colorWithRed:16/255.f green:97/255.f blue:181/255.f alpha:1.0f] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    _textField = [self.view textFieldWithFrame:CGRectMake(0, 0, kWindowWidth -40, 30) borderStyle:UITextBorderStyleNone backgroundColor:[UIColor whiteColor] text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.delegate = self;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    self.tableView.bounces = NO;
    _tableView.tableFooterView = _tableFooterView;
    [self.view addSubview:_tableView];
    
    switch (_type) {
        case ModifyCVTypeUserName:
        {
            _textField.text = _user.account;
            _tipLabel.text = @"注：用户名仅限修改一次";
            break;
        }
        case ModifyCVTypeHomeTel:
        {
            _textField.text = _user.homeTel;
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _tipLabel.text = @"";
            _textField.placeholder = @"请输入固定电话";
            break;
        }
        case ModifyCVTypeIdType:
        {
            _textField.text = _user.idCardNumber;
            _tipLabel.text = @"";
            _textField.placeholder = @"输入证件号码";
            _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            idTypes = @[@"身份证", @"军官证", @"护照"];
            idCardType = -1;
            CGRect frame = _textField.frame;
            frame.size.width = 200;
            _textField.frame = frame;
            break;
        }
        case ModifyCVTypeQQ:
        {
            _textField.text = _user.qq;
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _tipLabel.text = @"";
            _textField.placeholder = @"请输入QQ号码";
            break;
        }
        case ModifyCVTypeWeiXin:
        {
            _textField.text = _user.weixin;
            _tipLabel.text = @"";
            _textField.placeholder = @"请输入微信账号";
            break;
        }
        case ModifyCVTypeNickName:
        {
            _textField.text = _user.nickName;
            _tipLabel.text = @"";
            _textField.placeholder = @"请输入昵称";
            break;
        }
        default:
            break;
    }
    [_textField becomeFirstResponder];
}

- (void)save{
    if (_textField.text.length == 0) {
        //不能为空
        [self showTip:@"输入内容不能为空!!"];
        return;
    }
    switch (_type) {
        case ModifyCVTypeUserName:
        {
            if ([_textField.text isEqualToString:_user.account]) {
                //未修改
                return;
            }
            param = @{@"oldAccount": _user.account,
                      @"account":_textField.text,
                      @"accountChangeable":[NSString stringWithFormat:@"%d", _user.accountChangeable]};
            break;
        }
        case ModifyCVTypeHomeTel:
        {
            if (_textField.text.length < 8) {
                //不能为空
                [self showTip:@"请输入完整的固定电话!!"];
                return;
            }
            param = @{@"homeTel": _textField.text};
            break;
        }
        case ModifyCVTypeIdType:
        {
            if (idCardType == -1) {
                [self showTip:@"请选择证件类型"];
                return;
            }
            _user.idCardType = [NSString stringWithFormat:@"%d", idCardType];
            _user.idCardNumber = _textField.text;
            break;
        }
        case ModifyCVTypeQQ:
        {
            param = @{@"qq": _textField.text};
            break;
        }
        case ModifyCVTypeWeiXin:
        {
            param = @{@"weixin": _textField.text};
            break;
        }
        case ModifyCVTypeNickName:
        {
            param = @{@"nickName": _textField.text};
            break;
        }
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyMemberDetail{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            switch (_type) {
                case ModifyCVTypeNickName:
                {
                    _user.nickName = _textField.text;
                    break;
                }
                case ModifyCVTypeWeiXin:
                {
                    _user.weixin = _textField.text;
                    break;
                }
                case ModifyCVTypeQQ:
                {
                    _user.qq = _textField.text;
                    break;
                }
                case ModifyCVTypeHomeTel:
                {
                    _user.homeTel = _textField.text;
                    break;
                }
                case ModifyCVTypeUserName:
                {
                    _user.account = _textField.text;
                    _user.accountChangeable = YES;
                    break;
                }
                case ModifyCVTypeIdType:
                {
                    _user.idCardType = [NSString stringWithFormat:@"%d", idCardType];
                    _user.idCardNumber = _textField.text;
                    break;
                }
                default:
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([_delegate respondsToSelector:@selector(modifyCommit:)]) {
                    [_delegate modifyCommit:self];
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _type == ModifyCVTypeIdType?2:1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
    }
    cell.detailTextLabel.text = @"";
    
    if (_type == ModifyCVTypeIdType) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"证件信息";
            cell.detailTextLabel.text = idCardType == -1?@"请选择":idTypes[idCardType];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellIndicator.png"]];
        }else{
            cell.textLabel.text = @"证件号码";
            cell.accessoryView = _textField;
        }
    }else{
        cell.accessoryView = _textField;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_textField resignFirstResponder];
    if (_type == ModifyCVTypeIdType && indexPath.row == 0) {
        [UIActionSheet showInView:self.view withTitle:@"请选择证件类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:idTypes tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex != 3) {
                idCardType = buttonIndex;
                [_tableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger length = [Public convertToInt:toBeString];
    switch (_type) {
        case ModifyCVTypeNickName:
        case ModifyCVTypeUserName:
        {
            if (length > 12) {
                [self showTip:@"输入长度不超过12"];
                return NO;
            }
            break;
        }
        default:
            break;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}

@end

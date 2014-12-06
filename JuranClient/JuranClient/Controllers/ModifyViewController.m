//
//  ModifyViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ModifyViewController.h"
#import "JRMemberDetail.h"

@interface ModifyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *idTypes;
    NSInteger idCardType;
}
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;

@end

@implementation ModifyViewController

- (id)initWithMemberDetail:(JRMemberDetail*)memberDetail type:(ModifyCVType)type{
    self = [self init];
    if (self) {
        self.memberDetail = memberDetail;
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
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = _keyboardType;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    self.tableView.bounces = NO;
    _tableView.tableFooterView = _tableFooterView;
    [self.view addSubview:_tableView];
    
    switch (_type) {
        case ModifyCVTypeUserName:
        {
            _textField.text = _memberDetail.account;
            _tipLabel.text = @"注：用户名仅限修改一次";
            break;
        }
        case ModifyCVTypeHomeTel:
        {
            _textField.text = _memberDetail.homeTel;
            _tipLabel.text = @"";
            break;
        }
        case ModifyCVTypeIdType:
        {
            _textField.text = _memberDetail.idCardNumber;
            _tipLabel.text = @"";
            idTypes = @[@"身份证", @"军官证", @"护照"];
            idCardType = _memberDetail.idCardNumber.length == 0?-1:_memberDetail.idCardNumber.integerValue;
            break;
        }
        default:
            break;
    }
}

- (void)save{
    if (_textField.text.length == 0) {
        //不能为空
        return;
    }
    switch (_type) {
        case ModifyCVTypeUserName:
        {
            if ([_textField.text isEqualToString:_memberDetail.account]) {
                //未修改
                return;
            }
            _memberDetail.account = _textField.text;
            break;
        }
        case ModifyCVTypeHomeTel:
        {
            _memberDetail.homeTel = _textField.text;
            break;
        }
        case ModifyCVTypeIdType:
        {
            _memberDetail.idCardNumber = _textField.text;
            _memberDetail.idCardType = [NSString stringWithFormat:@"%d",idCardType];
            break;
        }
        default:
            break;
    }
    [self modifyMemberDetail];
    
}

- (void)modifyMemberDetail{
    NSDictionary *param = @{@"nickName": _memberDetail.nickName,
                            @"birthday": _memberDetail.birthday,
                            @"homeTel": _memberDetail.homeTel,
                            @"provinceCode": _memberDetail.provinceCode,
                            @"cityCode": _memberDetail.cityCode,
                            @"districtCode": _memberDetail.districtCode,
                            @"detailAddress": _memberDetail.detailAddress,
                            @"zipCode": _memberDetail.zipCode,
                            @"idCardType": _memberDetail.idCardType,
                            @"idCardNum": _memberDetail.idCardNumber,
                            @"qq": _memberDetail.qq,
                            @"weixin": _memberDetail.weixin,
                            @"account": _memberDetail.account,
                            @"sex": @"1"
                            };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_type == ModifyCVTypeIdType) {
        if (indexPath.row == 0) {
            cell.textLabel.text = idCardType == -1?@"选择证件类型":idTypes[idCardType];
        }else{
            cell.accessoryView = _textField;
        }
    }else{
        cell.accessoryView = _textField;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == ModifyCVTypeIdType && indexPath.row == 0) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

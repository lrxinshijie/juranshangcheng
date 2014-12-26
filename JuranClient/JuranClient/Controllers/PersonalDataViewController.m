//
//  PersonalDataViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalDatasMoreViewController.h"
#import "SexySwitch.h"
#import "ModifyViewController.h"
#import "BaseAddressViewController.h"
#import "DetailAddressViewController.h"
#import "JRAreaInfo.h"
#import "ALGetPhoto.h"
#import "ActionSheetDatePicker.h"
#import "TextFieldCell.h"

@interface PersonalDataViewController ()<UITableViewDataSource, UITableViewDelegate, SexySwitchDelegate, ModifyViewControllerDelegate, UITextFieldDelegate>
{
    NSDictionary *param;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SexySwitch *sexySwitch;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) UITextField *selectedTextField;

@end

@implementation PersonalDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    _tableView.delegate = nil; _tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"个人资料";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    [self setupDatas];
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    _sexySwitch = [[SexySwitch alloc] init];
    _sexySwitch.selectedIndex = 1;
    _sexySwitch.delegate = self;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_user) {
        [self reSetData];
        [_tableView reloadData];
    }
}

- (void)setupDatas{
    _keys = @[@[@"头像", @"用户名"], @[@"昵称", @"性别", @"生日", @"所在地", @"详细地址"], @[@"固定电话", @"证件信息", @"QQ", @"微信"]];
    _placeholders = @[@[@"", @"请输入用户名"], @[@"请输入昵称", @"", @"", @"", @""], @[@"请输入固定电话", @"", @"请输入QQ", @"请输入微信"]];
    _tags = @[@[@"", @"1100"], @[@"1101", @"", @"", @"", @""], @[@"1102", @"", @"1103", @"1104"]];
    
//    typesForSection3 = @[@(ModifyCVTypeHomeTel), @(ModifyCVTypeIdType),@(ModifyCVTypeQQ),@(ModifyCVTypeWeiXin)];
    /*
     *   设计师端个人资料
     *
     keysForSection1 = @[@"头像", @"用户名"];
     keysForSection2 = @[@"昵称", @"性别", @"生日", @"所在地"];
     keysForSection3 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍是老骥伏枥开离开就是离开对方极乐世界进口飞机来上课"];
     valuesForSection1 = @[@"头像", @"用户名"];
     valuesForSection1 = @[@"昵称", @"性别", @"生日", @"所在地"];
     valuesForSection1 = @[@"从业经验", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍"];
     */
    
}

- (void)reSetData{
    if (_user.headUrl && _user.headUrl.length>0) {
        [self.iconImageView setImageWithURLString:_user.headUrl];
    }
    _values = @[@[@"", _user.account], @[_user.nickName,
                                         @"",
                                         _user.birthday.length == 0?@"未设置":_user.birthday,
                                         [_user locationAddress],
                                         _user.detailAddress.length == 0?@"未设置":_user.detailAddress], @[[_user homeTelForPersonal], [_user idCardInfomation], _user.qq, _user.weixin]];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETMEMBERDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _user = [JRUser currentUser];
                [_user buildUpMemberDetailWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reSetData];
                    [_tableView reloadData];
                });
            }
        }
    }];
}

- (void)modifyMemberDetail{
    /*
    NSDictionary *param11 = @{@"nickName": _user.nickName,
                            @"birthday": _user.birthday,
                            @"homeTel": _user.homeTel,
                            @"provinceCode": _user.areaInfo.provinceCode,
                            @"cityCode": _user.areaInfo.cityCode,
                            @"districtCode": _user.areaInfo.districtCode,
                            @"detailAddress": _user.detailAddress,
                            @"zipCode": _user.zipCode,
                            @"idCardType": _user.idCardType,
                            @"idCardNum": _user.idCardNumber,
                            @"qq": _user.qq,
                            @"weixin": _user.weixin,
                            @"account": _user.account,
                            @"sex": @"1"
                        };
    */
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
//        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadData];
            });
        }else{
            [self hideHUD];
        }
    }];
}

- (void)uploadHeaderImage:(UIImage*)image{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            [[ALEngine shareEngine] pathURL:JR_UPLOAD_HEAD_IMAGE parameters:@{@"headUrl":[data objectForKey:@"imgUrl"]} HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:nil responseHandler:^(NSError *error, id data, NSDictionary *other) {
                if (!error) {
                    [self loadData];
                }
            }];
        }
    }];
    
}

#pragma mark - ModifyViewControllerDelegate

- (void)modifyCommit:(ModifyViewController *)vc{
    [self reSetData];
    [_tableView reloadData];
}

#pragma mark - SexySwitchDelegate

- (void)sexySwitch:(SexySwitch *)sexySwitch valueChange:(NSInteger)index{
    param = @{@"sex": [NSString stringWithFormat:@"%d", index]};
    [self modifyMemberDetail];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_keys[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 9;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     *  设计师端
     if (indexPath.section == 0 && indexPath.row == 0) {
     return 65;
     }else if (indexPath.section == 2 && indexPath.row == 6){
     return 70;
     }
     */
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row != 0) || (indexPath.section == 2 && indexPath.row == 1)) {
        static NSString *cellIdentifier = @"personalData";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:kSystemFontSize+2];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kSystemFontSize];
        }
        cell.accessoryView = [cell imageViewWithFrame:CGRectMake(0, 0, 8, 15) image:[UIImage imageNamed:@"cellIndicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"";
        
        if (indexPath.section == 0) {
            cell.textLabel.text = _keys[indexPath.section][indexPath.row];
            CGRect frame = CGRectMake(0, 0, 100, 50);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
            frame.size = CGSizeMake(8, 15);
            UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
            [view addSubview:arrowImageView];
            
            if (self.iconImageView.superview) {
                [self.iconImageView removeFromSuperview];
            }
            frame = self.iconImageView.frame;
            frame.origin = CGPointMake(view.frame.size.width - arrowImageView.frame.size.width - 10 -50, 0);
            self.iconImageView.frame = frame;
            [view addSubview:self.iconImageView];
            //            [self.iconImageView setImageWithURLString:_user.headUrl];
            cell.accessoryView = view;
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            cell.textLabel.text = _keys[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = @"";
            _sexySwitch.selectedIndex = _user.sex;
            cell.accessoryView = _sexySwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.textLabel.text = _keys[indexPath.section][indexPath.row];
            NSString *value = _values[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = _values[indexPath.section][indexPath.row];
            if ([value isEqualToString:@"未设置"]) {
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
        }
        return cell;
    }else{
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
        cell.textField.tag = [_tags[indexPath.section][indexPath.row] integerValue];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.textField.enabled = !_user.accountChangeable;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.titleLabel.text =  _keys[indexPath.section][indexPath.row];
        cell.textField.placeholder = _placeholders[indexPath.section][indexPath.row];
        cell.textField.text = _values[indexPath.section][indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 2)) {
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        return cell;
    }
    
        /*
         *设计师端内容
         if (indexPath.row == keysForSection3.count - 1) {
         cell.textLabel.text = valuesForSection3[indexPath.row];
         cell.detailTextLabel.text = @"";
         CGRect frame = CGRectMake(0, 0, 210, 53);
         UIView *view = [[UIView alloc] initWithFrame:frame];
         frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
         frame.size = CGSizeMake(8, 16);
         UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
         [view addSubview:arrowImageView];
         
         frame.origin = CGPointMake(view.frame.size.width - frame.size.width - 10 -190, 0);
         frame.size = CGSizeMake(190, 53);
         
         UILabel *label = [cell labelWithFrame:frame text:valuesForSection3[indexPath.row] textColor:cell.detailTextLabel.textColor textAlignment:NSTextAlignmentCenter font:cell.detailTextLabel.font];
         label.numberOfLines = 3;
         [view addSubview:label];
         
         cell.accessoryView = view;
         
         }else{
         cell.textLabel.text = keysForSection3[indexPath.row];
         cell.detailTextLabel.text = valuesForSection3[indexPath.row];
         }
         */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectedTextField resignFirstResponder];
    /*
     *设计师端
     if (indexPath.section == 3) {
     PersonalDatasMoreViewController *vc = [[PersonalDatasMoreViewController alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
     }
     */
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
            if (images.count > 0) {
                [self uploadHeaderImage:images[0]];
            }
        }];
        /*
         if (_user.accountChangeable) {
         [self showTip:@"用户名不可修改"];
         return;
         }
         ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_user type:ModifyCVTypeUserName];
         vc.title = keysForSection1[indexPath.row];
         [self.navigationController pushViewController:vc animated:YES];*/
    }else if (indexPath.section == 1){
        if (indexPath.row == 2) {
            [ActionSheetDatePicker showPickerWithTitle:@"生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                _user.birthday = [(NSDate*)selectedDate stringWithFormat:[NSDate dateFormatString]];
                NSString *dateString = [(NSDate*)selectedDate stringWithFormat:[NSDate timestampFormatString]];
                param = @{@"birthday": dateString};
                [self modifyMemberDetail];
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
        }else if (indexPath.row == 3){
            BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
            [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
                param = @{@"areaInfo": @{@"provinceCode": areaInfo.provinceCode,
                                         @"cityCode": areaInfo.cityCode,
                                         @"districtCode": areaInfo.districtCode
                                         }};
                [self modifyMemberDetail];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 4){
            DetailAddressViewController *vc = [[DetailAddressViewController alloc] init];
            vc.user = _user;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2 && indexPath.row == 1){
        ModifyViewController *vc = [[ModifyViewController alloc] initWithMemberDetail:_user type:ModifyCVTypeIdType];
        vc.title = _keys[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView*)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [self.view imageViewWithFrame:CGRectMake(0, 0, 50, 50) image:[UIImage imageNamed:@"unlogin_head.png"]];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height/2;
    }
    return _iconImageView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 1101 && [Public convertToInt:value] > 12) {
        return NO;
    }
//    else if (textField.tag == DemandEditContactsMobile && value.length > 32){
//        return NO;
//    }else if (textField.tag == DemandEditBudget){
//        double budget = [value doubleValue];
//        if (budget > 99999) {
//            return NO;
//        }
//    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == 0) {
//        _demand.contactsName = textField.text;
//    }else if (textField.tag == 1){
//        _demand.contactsMobile = textField.text;
//    }else if (textField.tag == 3){
//        _demand.budget = textField.text;
//    }else if (textField.tag == 4){
//        _demand.houseArea = [textField.text doubleValue];
//    }else if (textField.tag == 7){
//        _demand.neighbourhoods = textField.text;
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        //不能为空
        [self showTip:@"输入内容不能为空!!"];
        return NO;
    }
    switch (textField.tag) {
        case 1100:
        {
            if (_user.accountChangeable) {
                [self showTip:@"用户名不可修改"];
                return YES;
            }
            param = @{@"oldAccount": _user.account,
                      @"account":_selectedTextField.text,
                      @"accountChangeable":[NSString stringWithFormat:@"%d", _user.accountChangeable]};
            break;
        }
        case 1101:{
            param = @{@"nickName": _selectedTextField.text};
            break;
        }
        case 1102:{
            if (![self isPureNumandCharacters:_selectedTextField.text]) {
                [self showTip:@"请输入合法电话号码！！"];
                return NO;
            }
            if (_selectedTextField.text.length < 8 || _selectedTextField.text.length > 12) {
                //不能为空
                [self showTip:@"请输入合法电话号码！！"];
                return NO;
            }
            param = @{@"homeTel": _selectedTextField.text};
            break;
        }
        case 1103:{
            param = @{@"qq": _selectedTextField.text};
            break;
        }
        case 1104:{
            param = @{@"weixin": _selectedTextField.text};
            break;
        }
        default:
            break;
    }
    [textField resignFirstResponder];
    [self modifyMemberDetail];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation];
    CGRect frame = _tableView.frame;
    frame.size.height = kWindowHeightWithoutNavigationBar - keyboardSize.height;
    _tableView.frame = frame;
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    _tableView.frame = kContentFrameWithoutNavigationBar;
}

//判断是否为数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end

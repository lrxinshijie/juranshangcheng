//
//  PersonalDataForDesignerViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/8.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "PersonalDataForDesignerViewController.h"
#import "PersonalDatasMoreViewController.h"
#import "ModifyViewController.h"
#import "BaseAddressViewController.h"
#import "DetailAddressViewController.h"
#import "JRAreaInfo.h"
#import "ALGetPhoto.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "TextFieldCell.h"
#import "UIAlertView+Blocks.h"
#import "JRDesigner.h"
#import "PriceModifyViewController.h"
#import "StyleModifyViewController.h"
#import "PersonalDatasMoreViewController.h"

@interface PersonalDataForDesignerViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSDictionary *param;
    BOOL nickNameChangeTip;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) UITextField *selectedTextField;
@property (nonatomic, strong) NSString* oldNickName;

@end

@implementation PersonalDataForDesignerViewController

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
    
    _user = [[JRDesigner alloc] init];
    _oldNickName = @"";
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    [self setupDatas];
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStyleGrouped backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_user) {
        [self reloadData];
    }
}

- (void)reloadData{
    [self reSetData];
    [_tableView reloadData];
    
}

- (void)setupDatas{
    _keys = @[@[@"头像", @"用户名"], @[@"昵称", @"性别", @"生日", @"所在地"], @[@"从业经验(年)", @"设计费用", @"量房费用", @"擅长风格", @"设计专长", @"毕业院校", @"自我介绍"], @[@"更多资料"]];
    _placeholders = @[@[@"", @"请输入用户名"], @[@"请输入昵称", @"", @"", @""], @[@"请输入从业经验", @"", @"", @"", @"", @"请输入毕业院校", @""], @[@""]];
    _tags = @[@[@"", @"1100"], @[@"1101", @"", @"", @""], @[@"1102", @"", @"", @"", @"", @"1103", @""],@[@""]];
    
}

- (void)reSetData{
    if (_user.headUrl && _user.headUrl.length>0) {
        [self.iconImageView setImageWithURLString:_user.headUrl];
    }
    _values = @[@[@""
                  , _user.account]
                , @[_user.nickName
                    , [_user sexyString]
                    , _user.birthday.length == 0?@"未设置":_user.birthday
                    , _user.areaInfo.title
                    ]
                , @[[NSString stringWithFormat:@"%d", _user.experienceCount]
                    , [_user designPriceForPersonal]
                    , [_user measureForPersonal]
                    , [_user styleNameForPersonal]
                    , [_user specialForPersonal]
                    , _user.granuate
                    , _user.selfIntroduction]
                ,@[@""]
                ];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_DEDESIGNER_SELFDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [_user buildUpWithValueForPersonal:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
}

- (void)modifyMemberDetail{
    
    NSDictionary *param1 = @{@"nickName": _user.nickName,
                             @"oldNickName": self.oldNickName,
                             @"nickNameChangeable":_user.nickNameChangeable,
//                             @"mobilePhone": _user.mobilePhone,
                             @"birthday":_user.birthday,
                             @"areaInfo": @{@"provinceCode": _user.areaInfo.provinceCode,
                                            @"provinceName": _user.areaInfo.provinceName,
                                            @"cityCode": _user.areaInfo.cityCode,
                                            @"cityName": _user.areaInfo.cityName,
                                            @"districtCode": _user.areaInfo.districtCode,
                                            @"districtName": _user.areaInfo.districtName
                                            },
//                             @"detailAddress": _user.detailAddress,
                             @"idCardType": _user.idCardType,
                             @"idCardNum": _user.idCardNum,
                             @"qq": _user.qq,
                             @"weixin": _user.weixin,
                             @"sex": [NSString stringWithFormat:@"%d", _user.sex],
                             @"designExperience": [NSString stringWithFormat:@"%d", _user.experienceCount],
                             @"freeMeasure": [NSString stringWithFormat:@"%d", _user.freeMeasure],
                             @"priceMeasureStr": [NSString stringWithFormat:@"%d", (NSInteger)_user.priceMeasure],
                             @"style": _user.style,
                             @"special":_user.special,
                             @"graduateInstitutions":_user.granuate,
                             @"selfIntroduction":_user.selfIntroduction,
                             @"professional":_user.professional,
                             @"professionalType":_user.professionalType,
                             @"personalHonor":_user.personalHonor,
                             @"faceToFace": [NSString stringWithFormat:@"%d", _user.faceToFace],
                              @"chargeStandardMinStr": [NSString stringWithFormat:@"%d", (NSInteger)_user.designFeeMin],
                              @"chargeStandardMaxStr": [NSString stringWithFormat:@"%d", (NSInteger)_user.designFeeMax]
                             };
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_DESIGNINFO parameters:param1 HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProfileReloadData object:nil];
                [self showTip:@"修改用户信息成功"];
                if ([_user.nickName isEqualToString:self.oldNickName]) {
                    _user.nickNameChangeable = @"1";
                }
            });
            [self loadData];
        }
    }];
}

- (void)uploadHeaderImage:(UIImage*)image{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSString *imageUrl = [data objectForKey:@"imgUrl"];
            [[ALEngine shareEngine] pathURL:JR_UPLOAD_HEAD_IMAGE parameters:@{@"headUrl":imageUrl} HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:nil responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self hideHUD];
                if (!error) {
                    [self.iconImageView setImageWithURLString:imageUrl];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProfileReloadData object:nil];
                }
            }];
        }else{
            [self hideHUD];
        }
    }];
    
}

#pragma mark - Target Action

- (void)onSave{
    
    [self.selectedTextField resignFirstResponder];
    
    //判断合法性
    if (_user.account.length == 0) {
        [self showTip:@"用户名不能为空"];
        return;
    }
    
    if (_user.nickName.length < 2) {
        [self showTip:@"昵称至少需要2个字符"];
        return;
    }
    
    [self modifyMemberDetail];
    
}
/*
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
 */

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
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }else if (indexPath.section == 2 && indexPath.row == 6){
        return 70;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row != 0) || (indexPath.section == 2 && indexPath.row != 0 && indexPath.row != 5) ||indexPath.section == 3) {
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
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
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
            
        }else if (indexPath.section == 2 && indexPath.row == 6){
            cell.textLabel.text = _keys[indexPath.section][indexPath.row];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 60)];
            
            CGRect frame = view.frame;
            frame.origin = CGPointMake(0, 0);
            frame.size = CGSizeMake(frame.size.width - 15, 60);
            UILabel *label = [cell labelWithFrame:frame text:_values[indexPath.section][indexPath.row] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
            label.numberOfLines = 3;
            if ([label.text heightWithFont:label.font constrainedToWidth:CGRectGetWidth(label.frame)] < 20) {
                label.textAlignment = NSTextAlignmentRight;
            }
            [view addSubview:label];
            
            frame = view.frame;
            frame.origin = CGPointMake(frame.size.width - 8, (frame.size.height - 16)/2);
            frame.size = CGSizeMake(8, 15);
            UIImageView *arrowImageView = [cell imageViewWithFrame:frame image:[UIImage imageNamed:@"cellIndicator.png"]];
            [view addSubview:arrowImageView];
            
            
            //            [self.iconImageView setImageWithURLString:_user.headUrl];
            cell.accessoryView = view;
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.titleLabel.text =  _keys[indexPath.section][indexPath.row];
        cell.textField.placeholder = _placeholders[indexPath.section][indexPath.row];
        cell.textField.text = _values[indexPath.section][indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.textField.enabled = NO;
        }
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectedTextField resignFirstResponder];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
                if (images.count > 0) {
                    [self uploadHeaderImage:images[0]];
                }
            }];
        }else if (indexPath.row == 1){
            [self showTip:@"用户名不可更改!"];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            
            [ActionSheetStringPicker showPickerWithTitle:nil rows:@[@"女", @"男"] initialSelection:_user.sex ==0?0:(_user.sex - 1) doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                _user.sex= selectedIndex + 1;
                [self reloadData];
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:[UIApplication sharedApplication].keyWindow];
        }else if (indexPath.row == 2) {
            NSDate *date = [NSDate date];
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            [comp setMonth:date.month];
            [comp setDay:date.day];
            [comp setYear:date.year - 1];
            NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            date = [myCal dateFromComponents:comp];
            if (_user.birthday.length > 0) {
                date = [NSDate dateFromString:_user.birthday dateFormat:[NSDate dateFormatString]];
            }
            ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"生日" datePickerMode:UIDatePickerModeDate selectedDate:date doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                _user.birthday = [(NSDate*)selectedDate stringWithFormat:[NSDate dateFormatString]];
                [self reloadData];
            } cancelBlock:^(ActionSheetDatePicker *picker) {
            } origin:self.view];
            datePicker.maximumDate = [myCal dateFromComponents:comp];
            [comp setYear:[NSDate date].year - 60];
            datePicker.minimumDate = [myCal dateFromComponents:comp];
            [datePicker showActionSheetPicker];
        }else if (indexPath.row == 3){
            BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
            [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
                _user.areaInfo = areaInfo;
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:{
                break;
            }
            case 1:{
                PriceModifyViewController *vc = [[PriceModifyViewController alloc] init];
                vc.type = 0;
                vc.designer = _user;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                PriceModifyViewController *vc = [[PriceModifyViewController alloc] init];
                vc.type = 1;
                vc.designer = _user;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:{
                StyleModifyViewController *vc = [[StyleModifyViewController alloc] init];
                vc.type = 0;
                vc.designer = _user;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 4:{
                StyleModifyViewController *vc = [[StyleModifyViewController alloc] init];
                vc.type = 1;
                vc.designer = _user;
                [self.navigationController pushViewController:vc animated:YES];
                break;
                break;
            }
            case 5:{
                
                break;
            }
            case 6:{
                DetailAddressViewController *vc = [[DetailAddressViewController alloc] init];
                vc.user = _user;
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 3){
        PersonalDatasMoreViewController *vc = [[PersonalDatasMoreViewController alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    if (textField.tag == 1101 && [Public convertToInt:value] > 20) {
        [textField resignFirstResponder];
        [self showTip:@"昵称长度不能超过20个字符"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1101) {
        if (_user.nickNameChangeable.boolValue) {
            [self showTip:@"昵称仅限修改一次"];
            return NO;
        }else if(!nickNameChangeTip){
            self.selectedTextField = textField;
            [UIAlertView showWithTitle:@"" message:@"昵称只可修改一次，确定修改？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    nickNameChangeTip = YES;
                    [self.selectedTextField becomeFirstResponder];
                }
            }];
            return NO;
        }
    }
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1100) {
        _user.account = textField.text;
    }else if (textField.tag == 1101){
        _user.nickName = textField.text;
        self.oldNickName = _user.nickName;
        nickNameChangeTip = NO;
    }else if (textField.tag == 1102){
        _user.experienceCount = textField.text.integerValue;
    }else if (textField.tag == 1103){
        _user.granuate = textField.text;
    }
    [self reSetData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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

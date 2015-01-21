//
//  PersonalDataViewController.m
//  JuranClient
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PersonalDataViewController.h"
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


@interface PersonalDataViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSDictionary *param;
    BOOL accountChangeTip;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) UITextField *selectedTextField;
@property (nonatomic, strong) NSString* oldAccount;

//@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIImage *headImage;

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
    
    _user = [[JRUser alloc] init];
    _oldAccount = @"";
    
    self.rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave) title:@"保存" backgroundImage:nil];
    [_rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    
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
/*
- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (_isEditing) {
        [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_tableView reloadData];
    }else{
        [_rightButton setTitle:@"修改" forState:UIControlStateNormal];
        [_tableView reloadData];
    }
}*/

- (void)reloadData{
    [self reSetData];
    [_tableView reloadData];

}

- (void)setupDatas{
    _keys = @[@[@"头像", @"用户名"], @[@"昵称", @"性别", @"生日", @"所在地", @"详细地址"], @[@"固定电话", @"证件信息", @"QQ", @"微信"]];
    _placeholders = @[@[@"", @"请输入用户名"], @[@"请输入昵称", @"", @"", @"", @""], @[@"请输入固定电话", @"", @"请输入QQ", @"请输入微信"]];
    _tags = @[@[@"", @"1100"], @[@"1101", @"", @"", @"", @""], @[@"1102", @"", @"1103", @"1104"]];
    
}

- (void)reSetData{
    if (_headImage) {
        self.iconImageView.image = _headImage;
    }else if (_user.headUrl && _user.headUrl.length>0) {
        [self.iconImageView setImageWithURLString:_user.headUrl];
    }
    _values = @[@[@"", _user.account], @[_user.nickName,
                                         [_user sexyString],
                                         _user.birthday.length == 0?@"未设置":_user.birthday,
                                         [_user locationAddress],
                                         _user.detailAddress.length == 0?@"未设置":_user.detailAddress], @[_user.homeTel, [_user idCardInfomation], _user.qq, _user.weixin]];
}

- (void)loadData{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GETMEMBERDETAIL parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                [_user buildUpMemberDetailWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }
        }
    }];
}

- (void)modifyMemberDetail{
    
    NSDictionary *param1 = @{@"nickName": _user.nickName,
                            @"birthday": _user.birthday,
                            @"homeTel": _user.homeTel,
                             @"areaInfo": @{@"provinceCode": _user.areaInfo.provinceCode,
                                            @"cityCode": _user.areaInfo.cityCode,
                                            @"districtCode": _user.areaInfo.districtCode
                                            },
                            @"detailAddress": _user.detailAddress,
                            @"zipCode": _user.zipCode,
                            @"idCardType": _user.idCardType,
                            @"idCardNum": _user.idCardNum,
                            @"qq": _user.qq,
                            @"weixin": _user.weixin,
                             @"oldAccount": self.oldAccount,
                             @"account": _user.account,
                             @"accountChangeable": [NSString stringWithFormat:@"%d", _user.accountChangeable],
                            @"sex": [NSString stringWithFormat:@"%d", _user.sex],
                            @"headUrl":_user.headUrl
                        };
    
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param1 HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProfileReloadData object:nil];
                [self showTip:@"修改用户信息成功"];
//                self.isEditing = NO;
            });
            [self loadData];
        }
    }];
}

- (void)uploadHeaderImage:(UIImage*)image{
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_UPLOAD_IMAGE parameters:nil HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:@{@"files":image} responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            _headImage = nil;
            NSString *imageUrl = [data objectForKey:@"imgUrl"];
            /*
            [[ALEngine shareEngine] pathURL:JR_UPLOAD_HEAD_IMAGE parameters:@{@"headUrl":imageUrl} HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self imageDict:nil responseHandler:^(NSError *error, id data, NSDictionary *other) {
                [self hideHUD];
                if (!error) {
                    [self.iconImageView setImageWithURLString:imageUrl];
//                    self.isEditing = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProfileReloadData object:nil];
                }
            }];*/
            _user.headUrl = imageUrl;
            [self modifyMemberDetail];
        }else{
            [self hideHUD];
        }
    }];
    
}

#pragma mark - Target Action

- (void)onSave{
    /*
    if (self.isEditing) {
        
    }else{
        self.isEditing = YES;
    }*/
    
    [self.selectedTextField resignFirstResponder];
    
    //判断合法性
    if (_user.account.length == 0) {
        [self showTip:@"用户名不能为空"];
        return;
    }
    
    if (_user.nickName.length == 0) {
        [self showTip:@"昵称不能为空"];
        return;
    }
    
    if (_headImage) {
        [self uploadHeaderImage:_headImage];
    }else{
        [self modifyMemberDetail];
    }
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
//    if (!self.isEditing) {
//        return;
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectedTextField resignFirstResponder];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
            if (images.count > 0) {
                _headImage = images.firstObject;
                self.iconImageView.image = _headImage;
            }
        }];
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            
            NSMutableArray *rows = [NSMutableArray array];
            __block NSInteger ind = 0;
            NSArray *sexs = [[DefaultData sharedData] sex];
            [sexs enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
                [rows addObject:[row objectForKey:@"k"]];
                if ([[row objectForKey:@"v"] integerValue] == _user.sex) {
                    ind = idx;
                }
            }];
            
            [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:ind doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                NSArray *sexs = [[DefaultData sharedData] sex];
                _user.sex = [[[sexs objectAtIndex:selectedIndex] objectForKey:@"v"] integerValue];
                
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
    if (textField.tag == 1101 && [Public convertToInt:value] > 20) {
        [textField resignFirstResponder];
        [self showTip:@"昵称长度不能超过20个字符"];
        return NO;
    }
    
    if (textField.tag == 1102) {
        if(![self isPureNumandCharacters:string] && ![string isEqualToString:@"-"]){
            [self showTip:@"请输入合法字符！！"];
            return NO;
        }
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
    if (textField.tag == 1100) {
        if (_user.accountChangeable) {
            [self showTip:@"用户名仅限修改一次"];
            return NO;
        }else if(!accountChangeTip){
            self.selectedTextField = textField;
            [UIAlertView showWithTitle:@"" message:@"用户名只可修改一次，确定修改？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    accountChangeTip = YES;
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
        self.oldAccount = _user.account;
        accountChangeTip = NO;
        _user.account = textField.text;
    }else if (textField.tag == 1101){
        _user.nickName = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else if (textField.tag == 1102){
        _user.homeTel = textField.text;
    }else if (textField.tag == 1103){
        _user.qq = textField.text;
    }else if (textField.tag == 1104){
        _user.weixin = textField.text;
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

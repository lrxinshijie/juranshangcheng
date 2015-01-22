//
//  MeasureViewController.m
//  JuranClient
//
//  Created by Kowloon on 14/12/19.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "MeasureViewController.h"
#import "TextFieldCell.h"
#import "DesignerDetailViewController.h"
#import "JRDesigner.h"
#import "JRAreaInfo.h"
#import "BaseAddressViewController.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetMultiPicker.h"
#import "JRDemand.h"

@interface MeasureViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *selectedTextField;

@property (nonatomic, copy) NSString *customerRealName;
@property (nonatomic, copy) NSString *customerMobile;
@property (nonatomic, copy) NSString *customerEmail;
@property (nonatomic, copy) NSString *customerCardNo;
@property (nonatomic, copy) NSString *customerQQ;
@property (nonatomic, copy) NSString *customerWechat;
@property (nonatomic, copy) NSString *serviceDateKey;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, copy) NSString *livingroomCount;
@property (nonatomic, copy) NSString *bathroomCount;
@property (nonatomic, copy) NSString *houseArea;
@property (nonatomic, copy) NSString *designReqId;

@property (nonatomic, assign) NSInteger serviceDate;
@property (nonatomic, strong) JRAreaInfo *areaInfo;
@property (nonatomic, strong) UITapGestureRecognizer *tapHide;

@property (nonatomic, strong) IBOutlet UIView *designerView;
@property (nonatomic, strong) IBOutlet UILabel *designerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *designerImageView;

@end

@implementation MeasureViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"预约量房";
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 40, 30) target:self action:@selector(onSubmit) title:@"发送" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.customerRealName = @"";
    self.customerMobile = @"";
    self.customerEmail = @"";
    self.customerCardNo = @"";
    self.customerQQ = @"";
    self.customerWechat = @"";
    self.serviceDateKey = @"";
    self.address = @"";
    self.roomNum = @"";
    self.livingroomCount = @"";
    self.bathroomCount = @"";
    self.houseArea = @"";
    self.designReqId = @"";
    self.areaInfo = [[JRAreaInfo alloc] init];
    if (_demand) {
        self.customerRealName = _demand.contactsName;
        self.customerMobile = _demand.contactsMobile;
        self.address = _demand.neighbourhoods;
        self.roomNum = _demand.roomNum;
        self.livingroomCount = _demand.livingroomCount;
        self.bathroomCount = _demand.bathroomCount;
        self.houseArea = _demand.houseArea;
        self.areaInfo = _demand.areaInfo;
        self.designReqId = _demand.designReqId;
    }
    
    _designerImageView.layer.masksToBounds = YES;
    _designerImageView.layer.cornerRadius = CGRectGetHeight(_designerImageView.frame)/2;
    [_designerImageView setImageWithURLString:_designer.headUrl];
    _designerLabel.text = _designer.formatUserName;
    
    self.tableView = [self.view tableViewWithFrame:kContentFrameWithoutNavigationBar style:UITableViewStylePlain backgroundView:nil dataSource:self delegate:self];
    _tableView.backgroundColor = RGBColor(237, 237, 237);
    [self.view addSubview:_tableView];
    
    self.tapHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row <= 1) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        if (indexPath.row == 0) {
            [_designerView removeFromSuperview];
            [cell addSubview:_designerView];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"量房时间";
            cell.detailTextLabel.text = _serviceDateKey;
            if (_serviceDateKey.length == 0) {
                cell.detailTextLabel.text = @"请选择";
                cell.detailTextLabel.textColor = RGBColor(205, 205, 209);
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *CellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (TextFieldCell *)[nibs firstObject];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *placeholder = @"";
        NSString *title = @"";
        cell.textField.enabled = YES;
        cell.textField.tag = indexPath.row;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                placeholder = @"请选择";
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.text = [self roomNumString];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textField.enabled = NO;
                title = @"户型";
            }else if (indexPath.row == 3){
                placeholder = @"请输入数字";
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.textField.text = _houseArea;
                title = @"房屋面积(㎡)";
                cell.textField.tag = 99;
            }
        }else{
            if (indexPath.row == 0) {
                placeholder = @"请输入姓名";
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.text = _customerRealName;
                title = @"姓名";
            }else if (indexPath.row == 1) {
                placeholder = @"请输入11位手机号";
                cell.textField.text = _customerMobile;
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                title = @"手机号";
            }else if (indexPath.row == 2){
                placeholder = @"请输入数字";
                cell.textField.text = _customerCardNo;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                title = @"会员卡号";
            }else if (indexPath.row == 3){
                cell.textField.text = _customerEmail;
                placeholder = @"请输入邮箱";
                cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
                title = @"电子邮箱";
            }else if (indexPath.row == 4){
                placeholder = @"请输入文字";
                cell.textField.text = _customerQQ;
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                title = @"QQ";
            }else if (indexPath.row == 5){
                placeholder = @"请输入文字";
                cell.textField.text = _customerWechat;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                title = @"微信号";
            }else if (indexPath.row == 6){
                placeholder = @"请选择";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textField.text = _areaInfo.title;
                title = @"城市";
            }else if (indexPath.row == 7){
                placeholder = @"请输入文字";
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.text = _address;
                title = @"小区名称";
            }
        }
        
        
        cell.titleLabel.text = title;
        cell.textField.placeholder = placeholder;
        cell.textField.delegate = self;
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 64;
    }
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    headerView.backgroundColor = RGBColor(226, 226, 226);
    UILabel *label = [headerView labelWithFrame:CGRectMake(15, 0, 300, 30) text:@"联系人信息" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DesignerDetailViewController *detailVC = [[DesignerDetailViewController alloc] init];
            detailVC.designer = _designer;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (indexPath.row == 1) {
            NSArray *rows = @[@"只工作日",@"工作日、双休日与假日均可",@"只双休日、假日"];
            [ActionSheetStringPicker showPickerWithTitle:nil rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                self.serviceDate = [[@[@(1),@(2),@(3)] objectAtIndex:selectedIndex] intValue];
                self.serviceDateKey = [rows objectAtIndex:selectedIndex];
                [_tableView reloadData];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:[UIApplication sharedApplication].keyWindow];
        }else if (indexPath.row == 2){
            NSMutableArray *rows = [NSMutableArray array];
            NSMutableArray *selects = [NSMutableArray array];
            
            NSMutableArray *datas = [NSMutableArray array];
            __block NSInteger ind = 0;
            NSArray *roomNum = [[DefaultData sharedData] roomNum];
            [roomNum enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
                [datas addObject:[row objectForKey:@"k"]];
                if ([[row objectForKey:@"v"] isEqualToString:_roomNum]) {
                    ind = idx;
                }
            }];
            [rows addObject:datas];
            [selects addObject:@(ind)];
            
            ind = 0;
            NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
            datas = [NSMutableArray array];
            [livingroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
                [datas addObject:[row objectForKey:@"k"]];
                if ([[row objectForKey:@"v"] isEqualToString:_livingroomCount]) {
                    ind = idx;
                }
            }];
            [rows addObject:datas];
            [selects addObject:@(ind)];
            
            ind = 0;
            NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
            datas = [NSMutableArray array];
            [bathroomCount enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL *stop) {
                [datas addObject:[row objectForKey:@"k"]];
                if ([[row objectForKey:@"v"] isEqualToString:_bathroomCount]) {
                    ind = idx;
                }
            }];
            [rows addObject:datas];
            [selects addObject:@(ind)];
            
            [ActionSheetMultiPicker showPickerWithTitle:nil rows:rows initialSelection:selects doneBlock:^(ActionSheetMultiPicker *picker, NSArray *selectedIndexs, NSArray *selectedValues) {
                NSArray *roomNum = [[DefaultData sharedData] roomNum];
                _roomNum = [[roomNum objectAtIndex:[selectedIndexs[0] integerValue]] objectForKey:@"v"];
                
                NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
                _livingroomCount = [[livingroomCount objectAtIndex:[selectedIndexs[1] integerValue]] objectForKey:@"v"];
                
                NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
                _bathroomCount = [[bathroomCount objectAtIndex:[selectedIndexs[2] integerValue]] objectForKey:@"v"];
                
                [_tableView reloadData];
            } cancelBlock:^(ActionSheetMultiPicker *picker) {
                
            } origin:[UIApplication sharedApplication].keyWindow];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 6) {
            [self editAddress];
        }else{
            TextFieldCell *cell = (TextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
        }
    }
}

- (NSString *)roomNumString{
    
    NSMutableArray *retVals = [NSMutableArray array];
    //    if (_roomNum.length > 0) {
    //        return _roomNum;
    //    }
    
    NSArray *roomNum = [[DefaultData sharedData] roomNum];
    for (int i = 0; i<[roomNum count]; i++) {
        NSDictionary *row = [roomNum objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.roomNum]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
    for (int i = 0; i<[livingroomCount count]; i++) {
        NSDictionary *row = [livingroomCount objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.livingroomCount]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
    for (int i = 0; i<[bathroomCount count]; i++) {
        NSDictionary *row = [bathroomCount objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.bathroomCount]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    return [retVals componentsJoinedByString:@""];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 6) {
        [self editAddress];
        return NO;
    }
    self.selectedTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        self.customerRealName = textField.text;
    }else if (textField.tag == 1){
        self.customerMobile = textField.text;
    }else if (textField.tag == 2){
        self.customerCardNo = textField.text;
    }else if (textField.tag == 3){
        self.customerEmail = textField.text;
    }else if (textField.tag == 4){
        self.customerQQ = textField.text;
    }else if (textField.tag == 5){
        self.customerWechat = textField.text;
    }else if (textField.tag == 7){
        self.address = textField.text;
    }else if (textField.tag == 99){
        self.houseArea = textField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isContainsEmoji]) {
        return NO;
    }
    
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 1 && value.length > kPhoneMaxNumber) {
        return NO;
    }
    
    return YES;
}

- (void)editAddress{
    BaseAddressViewController *vc = [[BaseAddressViewController alloc] init];
    [vc setFinishBlock:^(JRAreaInfo *areaInfo) {
        self.areaInfo = areaInfo;
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSubmit{
    [self hideKeyboard];
    if (![self checkLogin]) {
        return;
    }
    
    if ([self roomNumString].length == 0) {
        [self showTip:@"户型不能为空"];
        return;
    }
    
    if (_houseArea.length == 0) {
        [self showTip:@"房屋面积不能为空"];
        return;
    }
    
    if (_customerRealName.length == 0) {
        [self showTip:@"姓名不能为空"];
        return;
    }
    
    if (_customerMobile.length == 0) {
        [self showTip:@"手机号码不能为空"];
        return;
    }
    
    if (![Public validateMobile:_customerMobile]) {
        [self showTip:@"手机号码不合法"];
        return;
    }
    
    if (_serviceDateKey.length == 0) {
        [self showTip:@"量房时间不能为空"];
        return;
    }
    
    if (_address.length == 0) {
        [self showTip:@"详细地址不能为空"];
        return;
    }
    
    if (_areaInfo.cityCode.length == 0) {
        [self showTip:@"城市不能为空"];
        return;
    }
    
    if (_customerEmail.length > 0 && ![_customerEmail validateEmail]) {
        [self showTip:@"电子邮箱不合法"];
        return;
    }
    
    [self showHUD];
    NSDictionary *param = @{@"designerId": [NSString stringWithFormat:@"%d", _designer.userId],
                            @"serviceDate":[NSString stringWithFormat:@"%d", _serviceDate],
                            @"customerRealName":_customerRealName,
                            @"customerMobile":_customerMobile,
                            @"customerCardNo": _customerCardNo,
                            @"customerQQ": _customerQQ,
                            @"customerWechat":_customerWechat,
                            @"customerEmail": _customerEmail,
                            @"address": _address,
                            @"areaInfo": [_areaInfo dictionaryValue],
                            @"houseArea": _houseArea,
                            @"roomNum": _roomNum,
                            @"livingroomNum": _livingroomCount,
                            @"bathroomNum": _bathroomCount,
                            @"bidId": _bidId?_bidId:@"",
                            @"designReqId": _designReqId};
    [[ALEngine shareEngine] pathURL:JR_APPLY_MEASURE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [self showTip:@"预约量房发送成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameMyDemandReloadData object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super back:nil];
            });
        }
    }];
}

- (void)hideKeyboard{
    [_selectedTextField resignFirstResponder];
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
    [_tableView addGestureRecognizer:_tapHide];
//    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification{
    _tableView.frame = kContentFrameWithoutNavigationBar;
    [_tableView removeGestureRecognizer:_tapHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
